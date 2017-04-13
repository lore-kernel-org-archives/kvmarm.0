From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: kvm/arm64: use-after-free in
 kvm_unmap_hva_handler/unmap_stage2_pmds
Date: Thu, 13 Apr 2017 16:53:26 +0100
Message-ID: <06ab8c28-031b-772f-6371-e3453b4bdbbe@arm.com>
References: <CAAeHK+yjKm3mO2h9M30t-V_PnMhXEM887_zESCSg6gkbzivPsQ@mail.gmail.com>
 <20f6c994-d83e-7a6f-9f13-f10287211a6c@arm.com>
 <9f473bb9-d0eb-6803-1263-75ffef0301fe@redhat.com>
 <CAAeHK+x8udHKq9xa1zkTO6ax5E8Dk32HYWfaT05FMchL2cr48g@mail.gmail.com>
 <1050c9d8-5813-5df9-29e5-3ab6e61b5de6@arm.com>
 <88715300-ef58-e7bd-81f5-95e0b9c9c533@arm.com>
 <20170413155045.GA8387@e107814-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7C7240A7B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Apr 2017 11:51:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t8IbXTB+b87C for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Apr 2017 11:51:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3D6440992
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Apr 2017 11:51:02 -0400 (EDT)
In-Reply-To: <20170413155045.GA8387@e107814-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Andrey Konovalov <andreyknvl@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kcc@google.com, syzkaller@googlegroups.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, dvyukov@google.com
List-Id: kvmarm@lists.cs.columbia.edu

On 13/04/17 16:50, Suzuki K. Poulose wrote:
> On Thu, Apr 13, 2017 at 10:17:54AM +0100, Suzuki K Poulose wrote:
>> On 12/04/17 19:43, Marc Zyngier wrote:
>>> On 12/04/17 17:19, Andrey Konovalov wrote:

Please ignore the footer below, that was mistake from my side.

> --
> 2.7.4
> IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
>
