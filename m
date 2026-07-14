Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAE441F34E
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 19:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784058331; cv=none; b=GqwIRWqb0GEzXhQuvf9mCJaNYHmTD4s7F3EK5R1VHtTR7fhEZ4kKxv2CpzgHaoEy6kIrO7ZeTT9qOE0tAdMS4yTjMxLBZbzT72DFbCH+ROZHmZYg//Barak7T0SKEN5psblmD/nSl5TQmN7K/kXH6AsnoTV7iqkttADkjbNLhMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784058331; c=relaxed/simple;
	bh=p541nDCL/jCI60DIsJS3A6WeK5slSxsH0NevU0g4BG8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cl/DEd698LmSRgnXIyz5CAnnU6ZJMGq/UDR13JW3XgaOfwrZJQoBQur1MU3KXWyJRkY2JPFQo9rcrqZXumqmATG+6ks3+X3BtTwZ3mk7dw8UQHu0J8TGctEGCnTSg4p/NLT53FDj8VDyYeYo3KjL8AAQCbJWYsn+4V6b5jzTUzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I8D2Cd/Y; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I8D2Cd/Y"
X-Forwarded-Encrypted: i=1; AHgh+Ro6igU0/F8ERf0YeZS99kftvO5lLbK+pU6WiCzrTOvtlEnuXccY5q1R0TXD51GqXd+/01Jc8cQ=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784058324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G7UqnmRNp9z0SOtGksM14OWDF721FdDHrzQmlOywusk=;
	b=I8D2Cd/YY3CGyJTuzrIFYoj5JINe8uFVqyvYys2jUkPhmhXplni1s+xGPjYXxxGo8461jR
	06eySjbdgyJnEzgBleI5CCT9Y9ddmSv1vdvbaBttQuR7+0z0gHw4x4RBDP6xLMautlszQ5
	NEirovOsgulOQiGS6qQyIaj4CoR6mrw=
X-Gm-Message-State: AOJu0YzOQa2ky1II5ozK+NhcRByZhEYy+X6GRWu10fo9+5gvPEIGQ9yC
	DOGWcIvrHhF/Py9K6mlITRXlqCkE3P/0HL6uBgnGdRvrI6sk39R0mx6P4YYEXtlGzw/z2SFsq6a
	SlZrm6VCXgU1Dl61dRiTwOTELV5702MwtDtWa9sPU
X-Received: by 2002:a05:622a:4d47:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-51d7bc5094cmr18195991cf.10.1784058306364; Tue, 14 Jul 2026
 12:45:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-8-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-8-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 20:45:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyM63=A+jLAPD_MHOKHM=KS_PeKxdD6s53GL7MzZzRjLQ@mail.gmail.com>
X-Gm-Features: AUfX_mygvh_NbeI0_5exPC82Fp0Y9FQvBOfPvo4tVhv8gReqUd8S06tPliOP4O4
Message-ID: <CA+EHjTyM63=A+jLAPD_MHOKHM=KS_PeKxdD6s53GL7MzZzRjLQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/18] KVM: arm64: Add pkvm_hyp_req infrastructure
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Introduce a struct pkvm_hyp_req to enable the pKVM hypervisor to request
> resources from the host.
>
> Provide serialisation helpers to transport these requests via SMCCC
> registers (starting from a2):
>
>   pkvm_hyp_req_to_smccc() to encode into the SMCCC args.
>   smccc_to_pkvm_hyp_req() to decode them.
>
> When the hypervisor raises a request, the host must handle it and retry
> the HVC. To automate this sequence, introduce the pkvm_call_hyp_req()
> macro. This intercepts pending requests, invokes the handler and retries
> the HVC.
>
> Additionally, introduce a trace event to track the handling of these
> requests.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

>
> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> index 870f7870bb62..0be1469e7874 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -203,6 +203,95 @@ struct pkvm_mapping {
>         u64 __subtree_last;     /* Internal member for interval tree */
>  };
>
> +enum pkvm_hyp_req_type {
> +       PKVM_HYP_NO_REQ = 0,
> +       __PKVM_HYP_REQ_TYPE_MAX,
> +};
> +
> +#define PKVM_HYP_REQ_SMCCC_ARG_SIZE_MAX \
> +       (sizeof(struct arm_smccc_res) - offsetof(struct arm_smccc_res, a2) - 1)
> +
> +struct pkvm_hyp_req {
> +       u8 type;
> +       union {
> +               struct {
> +                       u32     nr_pages;
> +               } mem;
> +               struct {
> +                       /* Helper for SMCCC encoding/decoding */
> +                       u8      args[PKVM_HYP_REQ_SMCCC_ARG_SIZE_MAX];
> +               } args;
> +       };
> +};
> +
> +static inline size_t pkvm_hyp_req_arg_size(u8 type)
> +{
> +       switch (type) {
> +       case PKVM_HYP_NO_REQ:
> +               return 0;
> +       default:
> +               WARN_ON(1);
> +       }
> +
> +       return 0;
> +}
> +
> +/* Encode the pending pkvm_hyp_req type into the SMCCC args */
> +static inline void
> +pkvm_hyp_req_to_smccc(struct kvm_cpu_context *host_ctxt, struct pkvm_hyp_req *req)
> +{
> +       u8 *dst, type = req->type;
> +       size_t size;
> +
> +       if (type == PKVM_HYP_NO_REQ || type >= __PKVM_HYP_REQ_TYPE_MAX) {
> +               host_ctxt->regs.regs[2] = 0;
> +               return;
> +       }
> +
> +       size = pkvm_hyp_req_arg_size(type);
> +       if (WARN_ON(size > PKVM_HYP_REQ_SMCCC_ARG_SIZE_MAX))
> +               return;
> +
> +       dst = (u8 *)&host_ctxt->regs.regs[2];
> +       *dst = type;
> +
> +       memcpy(dst + 1, &req->args, size);
> +}
> +
> +/* Return true if a pkvm_hyp_req has been decoded from the SMCCC args */
> +static inline bool smccc_to_pkvm_hyp_req(struct pkvm_hyp_req *req, struct arm_smccc_res *res)
> +{
> +       u8 *src = (u8 *)res + offsetof(struct arm_smccc_res, a2);
> +       u8 type = *src;
> +
> +       if (type == PKVM_HYP_NO_REQ || type >= __PKVM_HYP_REQ_TYPE_MAX)
> +               return false;
> +
> +       req->type = type;
> +       memcpy(&req->args, src + 1, pkvm_hyp_req_arg_size(type));
> +
> +       return true;
> +}
> +
> +int __pkvm_handle_smccc_req(struct arm_smccc_res *res);
> +
> +#define pkvm_call_hyp_req(f, ...)                                                              \
> +({                                                                                             \
> +       struct arm_smccc_res __res;                                                             \
> +       int __ret;                                                                              \
> +       do {                                                                                    \
> +               __ret = -1;                                                                     \
> +               arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(f), ##__VA_ARGS__, &__res);               \
> +               if (WARN_ON(__res.a0 != SMCCC_RET_SUCCESS))                                     \
> +                       break;                                                                  \
> +               __ret = __res.a1;                                                               \
> +               if (!__ret)                                                                     \
> +                       break;                                                                  \
> +               __ret = __pkvm_handle_smccc_req(&__res);                                        \
> +       } while (!__ret);                                                                       \
> +       __ret;                                                                                  \
> +})
> +
>  int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
>                              struct kvm_pgtable_mm_ops *mm_ops);
>  void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index e2c8714e8ccc..5ba8b81b8c6c 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -16,6 +16,9 @@
>
>  #include "hyp_constants.h"
>
> +#define CREATE_TRACE_POINTS
> +#include "trace_pkvm.h"
> +
>  DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
>
>  static struct memblock_region *hyp_memory = kvm_nvhe_sym(hyp_memory);
> @@ -617,3 +620,25 @@ bool pkvm_force_reclaim_guest_page(phys_addr_t phys)
>
>         return !ret || ret == -EAGAIN;
>  }
> +
> +static int pkvm_handle_hyp_req(struct pkvm_hyp_req *req)
> +{
> +       int ret = -EINVAL;
> +
> +       switch (req->type) {
> +       }
> +
> +       trace_kvm_handle_pkvm_hyp_req(req, ret);
> +
> +       return ret;
> +}
> +
> +int __pkvm_handle_smccc_req(struct arm_smccc_res *res)
> +{
> +       struct pkvm_hyp_req req;
> +
> +       if (smccc_to_pkvm_hyp_req(&req, res))
> +               return pkvm_handle_hyp_req(&req);
> +
> +       return res->a1;
> +}
> diff --git a/arch/arm64/kvm/trace_pkvm.h b/arch/arm64/kvm/trace_pkvm.h
> new file mode 100644
> index 000000000000..4bf57c12e7de
> --- /dev/null
> +++ b/arch/arm64/kvm/trace_pkvm.h
> @@ -0,0 +1,37 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#if !defined(_TRACE_PKVM_ARM64_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_PKVM_ARM64_KVM_H
> +
> +#include <linux/tracepoint.h>
> +#include <asm/kvm_pkvm.h>
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM kvm
> +
> +TRACE_EVENT(kvm_handle_pkvm_hyp_req,
> +       TP_PROTO(struct pkvm_hyp_req *req, int ret),
> +       TP_ARGS(req, ret),
> +
> +       TP_STRUCT__entry(
> +               __field(u8,     type)
> +               __field(int,    ret)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->type = req->type;
> +               __entry->ret = ret;
> +       ),
> +
> +       TP_printk("type: %u ret: %d",
> +                 __entry->type, __entry->ret)
> +);
> +
> +#endif /* _TRACE_PKVM_ARM64_KVM_H */
> +
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH .
> +#undef TRACE_INCLUDE_FILE
> +#define TRACE_INCLUDE_FILE trace_pkvm
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> --
> 2.55.0.rc2.803.g1fd1e6609c-goog
>
