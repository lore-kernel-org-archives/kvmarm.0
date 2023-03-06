Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63BC53B8;
	Mon,  6 Mar 2023 15:37:54 +0000 (UTC)
Received: by mail-lf1-f43.google.com with SMTP id s20so13263768lfb.11;
        Mon, 06 Mar 2023 07:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678117072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5hDMsqcdGIfiCOVeyjU4Ba4iMqQn+GOWjCwhWYk6SdI=;
        b=cg1/O1TWCoAT+12txvkiPpk8WOQTLsVbbyntUVywAm++PWVMzFM4JjQRWDOUOYRScg
         pvFU352A9exDJyfmr6d8LqJgbi0luBH+enT3u31nc54Hmh05vWYHCkSSe7oGk7lmhxyE
         gQSPcdZk5nGsoTod4x/9xM1gvrso7kjeMYYHWi2P08jqU+eAbw3oqFZsorHQ0S/CRtHA
         d+foYcEAUnenuImuL8oP9UXM5FRNCKBTKRUghgv+c1d+jCyNJQcf5Z8sqJZPTHfcasad
         gO4Za/039IiZBBKhDDxAJK9l/nUdtBwyQUaEdwEM3X27LHjxursB5jxdMGtDxQkwzSHu
         Mqpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678117072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5hDMsqcdGIfiCOVeyjU4Ba4iMqQn+GOWjCwhWYk6SdI=;
        b=SmtJg5YyMJbMxQdWRowXnMsZMbp3hUJciy14qz7kC3UyQPBN03QyIwHJ+7ruxVXw3P
         a3fDtUSPnkGinuDYt/GkShGNlo4tFFiJYDeYUqtcSv4kZttVMcJq/v8hKBOx2SbLNcGG
         TPN82dFvx+7+LL1wyxMBVTZG4GKnA2I/wAzG36yGud+iX/g6buKQiJ9E9ZKNx5kbATtP
         Zy7+aZiKzq5GgEFOHYfRPqFHC72lx2+QPqG8eQYHP9FC3wLZHhMo1FrwDsdAH+gNsDtO
         pnFbHxijgOWojTzAOeSt37GAamaUkP6V3hejOMsrTzT4DpOEkxsY+g+c+qZ1xrcnckqQ
         RSOA==
X-Gm-Message-State: AO0yUKXFLwfHtQwu3daGD7r2kWSSaOjphW6C/XSb7RVw3iWPDMEpKE0M
	fyWbPYhdsh/t+YfBsxNt80xU9B6G9VY=
X-Google-Smtp-Source: AK7set/mMWXfBFsiLU1XkaTiImOSmqnWmfXifYoeEmJfJYsfZbSf6DihYHx9KRJq7C6ZcNvQWlxpEQ==
X-Received: by 2002:a19:f011:0:b0:4cb:3a60:65c9 with SMTP id p17-20020a19f011000000b004cb3a6065c9mr2589865lfc.2.1678117072501;
        Mon, 06 Mar 2023 07:37:52 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id g22-20020ac25396000000b004cb14fa604csm1680397lfh.262.2023.03.06.07.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 07:37:52 -0800 (PST)
Date: Mon, 6 Mar 2023 17:37:51 +0200
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
Message-ID: <20230306173751.000026d4@gmail.com>
In-Reply-To: <20230127112932.38045-16-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
	<20230127112932.38045-1-steven.price@arm.com>
	<20230127112932.38045-16-steven.price@arm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 27 Jan 2023 11:29:19 +0000
Steven Price <steven.price@arm.com> wrote:

> MMIO emulation for a realm cannot be done directly with the VM's
> registers as they are protected from the host. However the RMM interface
> provides a structure member for providing the read/written value and

More details would be better for helping the review. I can only see the
emulated mmio value from the device model (kvmtool or kvm_io_bus) is put into
the GPRS[0] of the RecEntry object. But the rest of the flow is missing.

I guess RMM copies the value in the RecEntry.GPRS[0] to the target GPR in the
guest context in RMI_REC_ENTER when seeing RMI_EMULATED_MMIO. This is for
the guest MMIO read path.

How about the MMIO write path? I don't see where the RecExit.GPRS[0] is loaded
to a varible and returned to the userspace.

> we can transfer this to the appropriate VCPU's register entry and then
> depend on the generic MMIO handling code in KVM.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/kvm/mmio.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> index 3dd38a151d2a..c4879fa3a8d3 100644
> --- a/arch/arm64/kvm/mmio.c
> +++ b/arch/arm64/kvm/mmio.c
> @@ -6,6 +6,7 @@
>  
>  #include <linux/kvm_host.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/rmi_smc.h>
>  #include <trace/events/kvm.h>
>  
>  #include "trace.h"
> @@ -109,6 +110,9 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>  			       &data);
>  		data = vcpu_data_host_to_guest(vcpu, data, len);
>  		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
> +
> +		if (vcpu_is_rec(vcpu))
> +			vcpu->arch.rec.run->entry.gprs[0] = data;

I think the guest context is maintained by RMM (while KVM can only touch
Rec{Entry, Exit} object) so that guest context in the legacy VHE mode is
unused.

If yes, I guess here is should be:

if (unlikely(vcpu_is_rec(vcpu)))
	vcpu->arch.rec.run->entry.gprs[0] = data;
else
	vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);

>  	}
>  
>  	/*
> @@ -179,6 +183,9 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  	run->mmio.len		= len;
>  	vcpu->mmio_needed	= 1;
>  
> +	if (vcpu_is_rec(vcpu))
> +		vcpu->arch.rec.run->entry.flags |= RMI_EMULATED_MMIO;
> +

Wouldn't it be better to set this in the kvm_handle_mmio_return where the MMIO
read emulation has been surely successful?

>  	if (!ret) {
>  		/* We handled the access successfully in the kernel. */
>  		if (!is_write)

