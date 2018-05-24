From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 09/14] ARM: spectre-v2: add PSCI based hardening
Date: Thu, 24 May 2018 13:03:50 +0100
Message-ID: <ffeddbce-2cf7-c1d9-573b-dc4c38d1cbd7@arm.com>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
 <E1fKjFT-00064F-Bs@rmk-PC.armlinux.org.uk>
 <35edb3df-fed4-b6e6-be0c-ee758618c92e@arm.com>
 <20180523194503.GX17671@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180523194503.GX17671@n2100.armlinux.org.uk>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Florian Fainelli <f.fainelli@gmail.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 23/05/18 20:45, Russell King - ARM Linux wrote:
> On Tue, May 22, 2018 at 06:24:13PM +0100, Marc Zyngier wrote:
>> On 21/05/18 12:45, Russell King wrote:
>>> +#ifdef CONFIG_ARM_PSCI
>>> +	if (psci_ops.smccc_version != SMCCC_VERSION_1_0) {
>>> +		struct arm_smccc_res res;
>>> +
>>> +		switch (psci_ops.conduit) {
>>> +		case PSCI_CONDUIT_HVC:
>>> +			arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
>>> +					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
>>> +			if ((int)res.a0 < 0)
>>> +				break;
>>
>> I just realised that there is a small, but significant difference
>> between this and the arm64 version: On arm64, we have a table of
>> vulnerable implementations, and we try the mitigation on a per-cpu
>> basis. Here, you entirely rely on the firmware to discover whether the
>> CPU needs mitigation or not. You then need to check for a return value
>> of 1, which indicates that although the mitigation is implemented, it is
>> not required on this particular CPU.
> 
> Okay, so digging further into the documentation seems to suggest that we
> only need to check the firmware for A72 and A57 CPUs, and given this
> statement:
> 
> "Arm recommends that the caller only call this on PEs for which a
>  firmware based mitigation of CVE-2017-5715 is required, or where
>  a local workaround is infeasible."
> 
> it seems that the right answer is to ignore the PSCI based methods when
> we have anything but these CPUs.  Do you agree?

For CPUs that are produced by ARM, I agree. I don't know about CPUs
produced by ARM licensees though, so I'd rather use the opposite logic:
Use the firmware unless the CPU is one of those that can be easily
mitigated at EL1 (or isn't affected).

>> But that's probably moot if you don't support BL systems.
> 
> Any bL systems with A72 or A57?

Juno is a canonical example of such a system (either 2xA57+4xA53, or
2xA72+4xA53), and there is plenty of partner's silicon in the wild.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
