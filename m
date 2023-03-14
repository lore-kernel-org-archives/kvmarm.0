Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD038F69;
	Tue, 14 Mar 2023 15:44:40 +0000 (UTC)
Received: by mail-lf1-f50.google.com with SMTP id t11so20597129lfr.1;
        Tue, 14 Mar 2023 08:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678808678; x=1681400678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cgTpDdjkEtDwUyqMsKfKimgkpTko/+U4mjHsdeCCyAw=;
        b=jn+4fsbltc9iHB3Pg5GN3DIZTz8zMRzUeKeAIzOiTyYvXPUn/3asS8Ueyq6cSIzv7b
         KfOshWG4YecYkTM5ULwjC66WFhoMkDdpEsW4UewwGMGhucUoNikdZIvciTL/i9szXTHL
         FaSQuKBvVTEdjgSN5O6bAMSKQAoFg5wFR7nLwLZaGgpQ03j2Xwo8SL9alAhePo7gOL2n
         gpbcyWjJKAS45cJ/PMATN1DElGUDwNAQsfI9nSwIb+Z5CNVqPov6+NDgMeku5Ypt6UEC
         AGzG6Fg35jFPB1Wjjd8Bq8F4T8S93tyGqnVoDw03OQJy9gifmcrNyqbXz9WIeArpE2BA
         /p/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678808678; x=1681400678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cgTpDdjkEtDwUyqMsKfKimgkpTko/+U4mjHsdeCCyAw=;
        b=LXh7LN5gQLqIgiZGpCwP8lv1E9d4WVc+n2n9QD4GEEnd1s71ybYjgcyWYAvuYFIgNm
         q4QQ7ChLO8u3sjGACbDo4wxFoNf+yziRIAPRNQbQp0Baq+GS84ZAyxGveTOf0AjIj8/T
         e7y+x7L4ene6m5sU9/3pQFuI9F7NdmWDrAIH6u6P/jSpm4t+GhnBVyXhF7fC+FnQ1PO8
         Tk3Z6KDSwajbrtsHVyPlS4uAfWX41DFwZ+BTUeE9Flkeg23wDCZFIbOupWanZ6ao4Txy
         SPXT02craT/sOIGDpFhVRqSl3pYH8fUUOuk4gCIIVB0OCS8AozJQFxTZJyZjZC9yDp0U
         RrLg==
X-Gm-Message-State: AO0yUKW5invht39G+EMsF0O81ewSRbmxJrg2MLhxlExquAchgk2dTsvR
	Gm1i2kRUJBFDgssqaeBQLEo=
X-Google-Smtp-Source: AK7set9Y1zV5rLAEEvjenaYbvtewXbHCXiE3dOYMiaGQa6T/jHn8v6l35bVSLf5V1f4SsCB9xAyJDg==
X-Received: by 2002:ac2:5239:0:b0:4db:3467:f2ff with SMTP id i25-20020ac25239000000b004db3467f2ffmr62296lfl.5.1678808678111;
        Tue, 14 Mar 2023 08:44:38 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id w16-20020ac25990000000b004cb1de3f487sm443117lfn.104.2023.03.14.08.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 08:44:38 -0700 (PDT)
Date: Tue, 14 Mar 2023 17:44:36 +0200
From: Zhi Wang <zhi.wang.linux@gmail.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Catalin Marinas
 <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon
 <will@kernel.org>, James Morse <james.morse@arm.com>, Oliver Upton
 <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, Alexandru
 Elisei <alexandru.elisei@arm.com>, Christoffer Dall
 <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH 15/28] KVM: arm64: Handle realm MMIO emulation
Message-ID: <20230314174436.0000584d@gmail.com>
In-Reply-To: <e0354676-e8cf-6ea0-3229-a55d90259f8e@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
	<20230127112932.38045-1-steven.price@arm.com>
	<20230127112932.38045-16-steven.price@arm.com>
	<20230306173751.000026d4@gmail.com>
	<e0354676-e8cf-6ea0-3229-a55d90259f8e@arm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 Mar 2023 15:47:14 +0000
Steven Price <steven.price@arm.com> wrote:

> On 06/03/2023 15:37, Zhi Wang wrote:
> > On Fri, 27 Jan 2023 11:29:19 +0000
> > Steven Price <steven.price@arm.com> wrote:
> >   
> >> MMIO emulation for a realm cannot be done directly with the VM's
> >> registers as they are protected from the host. However the RMM interface
> >> provides a structure member for providing the read/written value and  
> > 
> > More details would be better for helping the review. I can only see the
> > emulated mmio value from the device model (kvmtool or kvm_io_bus) is put into
> > the GPRS[0] of the RecEntry object. But the rest of the flow is missing.  
> 
> The commit message is out of date (sorry about that). A previous version
> of the spec had a dedicated member for the read/write value, but this
> was changed to just use GPRS[0] as you've spotted. I'll update the text.
> 
> > I guess RMM copies the value in the RecEntry.GPRS[0] to the target GPR in the
> > guest context in RMI_REC_ENTER when seeing RMI_EMULATED_MMIO. This is for
> > the guest MMIO read path.  
> 
> Yes, when entering the guest after an (emulatable) read data abort the
> value in GPRS[0] is loaded from the RecEntry structure into the
> appropriate register for the guest.
> 
> > How about the MMIO write path? I don't see where the RecExit.GPRS[0] is loaded
> > to a varible and returned to the userspace.  
> 

-----
> The RMM will populate GPRS[0] with the written value in this case (even
> if another register was actually used in the instruction). We then
> transfer that to the usual VCPU structure so that the normal fault
> handling logic works.
> 
-----

Are these in this patch or another patch?

> >> we can transfer this to the appropriate VCPU's register entry and then
> >> depend on the generic MMIO handling code in KVM.
> >>
> >> Signed-off-by: Steven Price <steven.price@arm.com>
> >> ---
> >>  arch/arm64/kvm/mmio.c | 7 +++++++
> >>  1 file changed, 7 insertions(+)
> >>
> >> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> >> index 3dd38a151d2a..c4879fa3a8d3 100644
> >> --- a/arch/arm64/kvm/mmio.c
> >> +++ b/arch/arm64/kvm/mmio.c
> >> @@ -6,6 +6,7 @@
> >>  
> >>  #include <linux/kvm_host.h>
> >>  #include <asm/kvm_emulate.h>
> >> +#include <asm/rmi_smc.h>
> >>  #include <trace/events/kvm.h>
> >>  
> >>  #include "trace.h"
> >> @@ -109,6 +110,9 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
> >>  			       &data);
> >>  		data = vcpu_data_host_to_guest(vcpu, data, len);
> >>  		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
> >> +
> >> +		if (vcpu_is_rec(vcpu))
> >> +			vcpu->arch.rec.run->entry.gprs[0] = data;  
> > 
> > I think the guest context is maintained by RMM (while KVM can only touch
> > Rec{Entry, Exit} object) so that guest context in the legacy VHE mode is
> > unused.
> > 
> > If yes, I guess here is should be:
> > 
> > if (unlikely(vcpu_is_rec(vcpu)))
> > 	vcpu->arch.rec.run->entry.gprs[0] = data;
> > else
> > 	vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);  
> 
> Correct. Although there's no harm in updating with vcpu_set_reg(). But
> I'll make the change because it's clearer.
> 
> >>  	}
> >>  
> >>  	/*
> >> @@ -179,6 +183,9 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
> >>  	run->mmio.len		= len;
> >>  	vcpu->mmio_needed	= 1;
> >>  
> >> +	if (vcpu_is_rec(vcpu))
> >> +		vcpu->arch.rec.run->entry.flags |= RMI_EMULATED_MMIO;
> >> +  
> > 
> > Wouldn't it be better to set this in the kvm_handle_mmio_return where the MMIO
> > read emulation has been surely successful?  
> 
> Yes, that makes sense - I'll move this.
> 
> Thanks,
> 
> Steve
> 
> >>  	if (!ret) {
> >>  		/* We handled the access successfully in the kernel. */
> >>  		if (!is_write)  
> >   
> 

