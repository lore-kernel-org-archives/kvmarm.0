From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v2 0/8] arm64: Support for systems without AArch32 state
Date: Wed, 2 Mar 2016 15:25:59 +0000
Message-ID: <56D70607.7090903@arm.com>
References: <1456393968-17386-1-git-send-email-suzuki.poulose@arm.com>
 <20160301211923.GA1325@yury-N73SV> <20160302150721.GA16286@yury-N73SV>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160302150721.GA16286@yury-N73SV>
Sender: linux-kernel-owner@vger.kernel.org
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 02/03/16 15:07, Yury Norov wrote:
> On Wed, Mar 02, 2016 at 12:19:23AM +0300, Yury Norov wrote:
>> On Thu, Feb 25, 2016 at 09:52:40AM +0000, Suzuki K Poulose wrote:
>>> This series add checks to make sure that the AArch32 state is
>>> supported before we process the 32bit ID registers. Also
>>> checks the same for COMPAT binary execution.

...

>
> So, everything is looking OK.
>
> Tested-by: Yury Norov <ynorov@caviumnetworks.com>

Thanks Yury.

Suzuki
