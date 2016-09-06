From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 7/7] ARM: KVM: Unlock vgic-v3 support
Date: Tue, 6 Sep 2016 14:08:10 +0100
Message-ID: <57CEBFBA.6060109@arm.com>
References: <1471344418-19568-1-git-send-email-vladimir.murzin@arm.com>
 <1471344418-19568-8-git-send-email-vladimir.murzin@arm.com>
 <20160905112927.GL26366@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2779549B4C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:59:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XVAgDN4q3IDC for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 08:59:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E9C1407A5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 08:59:49 -0400 (EDT)
In-Reply-To: <20160905112927.GL26366@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Vladimir Murzin <vladimir.murzin@arm.com>
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/09/16 12:29, Christoffer Dall wrote:
> On Tue, Aug 16, 2016 at 11:46:58AM +0100, Vladimir Murzin wrote:
>> It is time to get access to common version of vgic-v3.
> 
> common version?
> 
>>
>> We basically would need to tell build system how to pick it up and
>> undo KVM_ARM_VGIC_V3 guarding introduced in 4f64cb6 ("arm/arm64: KVM:
>> Only allow 64bit hosts to build VGICv3") and remove stubs. However,
>> since vgic got ITS support KVM_ARM_VGIC_V3 tend to protect a little
>> bit more than just plain vgic-v3 - this guard is used for ITS too
>> which is not supported in 32-bit world yet.  So, along with removal of
>> KVM_ARM_VGIC_V3 guard introduce the new one - KVM_ARM_VGIC_V3_ITS to
>> protect ITS related code.
> 
> I don't find this paragraph particularly helpful, I'm afraid.
> 
>>
>> The only unpleasant part is how we decide which save/restore sequence to
>> use under __vgic_save_state() - we don't have patching framework in hand
>> like arm64, so have to check runtime on every invocation.
> 
> Do static keys work on 32-bit arm?

They do. It'd be interesting to see if we could move both architectures
to use static keys for selecting the GIC backend.

	M.
-- 
Jazz is not dead. It just smells funny...
