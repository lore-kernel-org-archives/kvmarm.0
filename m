Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DC43F65E6
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782483772; cv=none; b=R3bgXrFBpfKiK/FSDz5SpWOzcbsUOvM108oBoUEExasIPdSZoJPA38vi94nUdNBrxgvFYBGFluVmRsloOXOjiIv+KN2XKXe9HsKsgdkKNgkb/K2P0gtSvELwXxaBfcpP70kBMcti+mlCE/bdr+dtRBnSubhfopfjrIYKnoAsj5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782483772; c=relaxed/simple;
	bh=cXaqsM1PpKfaMoOs9eaSaUzWG3Uc7ETrUGcmj3/0kIo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=lLjzYZVsmd6D//W+8bzPHKCQel6PcMnLcNM5cXOTXnQuQinMe5B2lI+4P0U8pkk5oXYJQhp9CfmmPbA0nn0Kf97LSZd5GbGcSFMWQWaboVQnuefKlhb1Em4z0m6xXRO5kAB1rROFLXIkJk4l8CSDt1KAi+lUDHQyrKiUNs3LzDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cmbGKR+a; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cmbGKR+a"
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782483765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sXG8afNs3yklXPbprHmJENAjnx3o20Btd5uIVU420b8=;
	b=cmbGKR+aou02UPg0yNfg6EUU0La0FotxxR6hFPLMLLx0i5lyy0uaFlAgbddgfY7BgaEqsZ
	Avp7TJZOyigFd/b6E8iMjLcwLrplB8eRe2p1FXE6V2RLxfwUhMhmUh4RVdZbwmBV1PhoSu
	DO+3c0Hx0lG9DdahENlsDEcvPZ/2SDM=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 14:22:35 +0000
Message-Id: <DJJ1R8VB5H31.1XJ69GVCYMB87@linux.dev>
Subject: Re: [PATCH v12 13/16] KVM: selftests: Add guest_memfd based
 vm_mem_backing_src_types
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
 <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
 <kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
 <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net"
 <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
 <oupton@kernel.org>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
 <yuzenghui@huawei.com>, "catalin.marinas@arm.com"
 <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
 "seanjc@google.com" <seanjc@google.com>, "tglx@kernel.org"
 <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
 <bp@alien8.de>, "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
 "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org"
 <willy@infradead.org>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
 "mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org"
 <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org"
 <song@kernel.org>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
 <kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>,
 "haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org"
 <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
 <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>,
 "jannh@google.com" <jannh@google.com>, "pfalcato@suse.de"
 <pfalcato@suse.de>, "skhan@linuxfoundation.org"
 <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com"
 <jgross@suse.com>, "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>, "yosry@kernel.org"
 <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com"
 <tabba@google.com>, "prsampat@amd.com" <prsampat@amd.com>,
 "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com"
 <jmattson@google.com>, "jthoughton@google.com" <jthoughton@google.com>,
 "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "alex@ghiti.fr"
 <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
 "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
 "gor@linux.ibm.com" <gor@linux.ibm.com>, "hca@linux.ibm.com"
 <hca@linux.ibm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "pjw@kernel.org" <pjw@kernel.org>, "shijie@os.amperecomputing.com"
 <shijie@os.amperecomputing.com>, "svens@linux.ibm.com"
 <svens@linux.ibm.com>, "thuth@redhat.com" <thuth@redhat.com>,
 "yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com"
 <urezki@gmail.com>, "zhengqi.arch@bytedance.com"
 <zhengqi.arch@bytedance.com>, "gerald.schaefer@linux.ibm.com"
 <gerald.schaefer@linux.ibm.com>, "jiayuan.chen@shopee.com"
 <jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>,
 "pavel@kernel.org" <pavel@kernel.org>, "rafael@kernel.org"
 <rafael@kernel.org>, "yangyicong@hisilicon.com" <yangyicong@hisilicon.com>,
 "vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
 <jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>
References: <20260410151746.61150-1-kalyazin@amazon.com>
 <20260410151746.61150-14-kalyazin@amazon.com>
In-Reply-To: <20260410151746.61150-14-kalyazin@amazon.com>
X-Migadu-Flow: FLOW_OUT

On Fri Apr 10, 2026 at 3:20 PM UTC, Nikita Kalyazin wrote:
> From: Patrick Roy <patrick.roy@linux.dev>
>
> Allow selftests to configure their memslots such that userspace_addr is
> set to a MAP_SHARED mapping of the guest_memfd that's associated with
> the memslot. This setup is the configuration for non-CoCo VMs, where all
> guest memory is backed by a guest_memfd whose folios are all marked
> shared, but KVM is still able to access guest memory to provide
> functionality such as MMIO emulation on x86.
>
> Add backing types for normal guest_memfd, as well as direct map removed
> guest_memfd.
>
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  | 18 ++++++
>  .../testing/selftests/kvm/include/test_util.h |  7 +++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 61 ++++++++++---------
>  tools/testing/selftests/kvm/lib/test_util.c   |  8 +++
>  4 files changed, 65 insertions(+), 29 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
> index 8b39cb919f4f..056a003a63c0 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -664,6 +664,24 @@ static inline bool is_smt_on(void)
> =20
>  void vm_create_irqchip(struct kvm_vm *vm);
> =20
> +static inline uint32_t backing_src_guest_memfd_flags(enum vm_mem_backing=
_src_type t)
> +{
> +	uint32_t flags =3D 0;
> +
> +	switch (t) {
> +	case VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP:
> +		flags |=3D GUEST_MEMFD_FLAG_NO_DIRECT_MAP;
> +		fallthrough;
> +	case VM_MEM_SRC_GUEST_MEMFD:
> +		flags |=3D GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return flags;
> +}
> +
>  static inline int __vm_create_guest_memfd(struct kvm_vm *vm, uint64_t si=
ze,
>  					uint64_t flags)
>  {
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/test=
ing/selftests/kvm/include/test_util.h
> index 8140e59b59e5..ea6de20ce8ef 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -152,6 +152,8 @@ enum vm_mem_backing_src_type {
>  	VM_MEM_SRC_ANONYMOUS_HUGETLB_16GB,
>  	VM_MEM_SRC_SHMEM,
>  	VM_MEM_SRC_SHARED_HUGETLB,
> +	VM_MEM_SRC_GUEST_MEMFD,
> +	VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP,
>  	NUM_SRC_TYPES,
>  };
> =20
> @@ -184,6 +186,11 @@ static inline bool backing_src_is_shared(enum vm_mem=
_backing_src_type t)
>  	return vm_mem_backing_src_alias(t)->flag & MAP_SHARED;
>  }
> =20
> +static inline bool backing_src_is_guest_memfd(enum vm_mem_backing_src_ty=
pe t)
> +{
> +	return t =3D=3D VM_MEM_SRC_GUEST_MEMFD || t =3D=3D VM_MEM_SRC_GUEST_MEM=
FD_NO_DIRECT_MAP;
> +}
> +
>  static inline bool backing_src_can_be_huge(enum vm_mem_backing_src_type =
t)
>  {
>  	return t !=3D VM_MEM_SRC_ANONYMOUS && t !=3D VM_MEM_SRC_SHMEM;
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index 5b0865683047..fa4a2fc236fe 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1046,6 +1046,33 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_bac=
king_src_type src_type,
>  	alignment =3D 1;
>  #endif
> =20
> +	if (guest_memfd < 0) {
> +		if ((flags & KVM_MEM_GUEST_MEMFD) || backing_src_is_guest_memfd(src_ty=
pe)) {
> +			uint32_t guest_memfd_flags =3D backing_src_guest_memfd_flags(src_type=
);
> +
> +			TEST_ASSERT(!guest_memfd_offset,
> +				    "Offset must be zero when creating new guest_memfd");
> +			guest_memfd =3D vm_create_guest_memfd(vm, mem_size, guest_memfd_flags=
);
> +		}
> +	} else {
> +		/*
> +		 * Install a unique fd for each memslot so that the fd
> +		 * can be closed when the region is deleted without
> +		 * needing to track if the fd is owned by the framework
> +		 * or by the caller.
> +		 */
> +		guest_memfd =3D kvm_dup(guest_memfd);
> +	}
> +
> +	if (guest_memfd >=3D 0) {
> +		flags |=3D KVM_MEM_GUEST_MEMFD;
> +
> +		region->region.guest_memfd =3D guest_memfd;
> +		region->region.guest_memfd_offset =3D guest_memfd_offset;
> +	} else {
> +		region->region.guest_memfd =3D -1;
> +	}
> +
>  	/*
>  	 * When using THP mmap is not guaranteed to returned a hugepage aligned
>  	 * address so we have to pad the mmap. Padding is not needed for HugeTL=
B
> @@ -1061,10 +1088,13 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_ba=
cking_src_type src_type,
>  	if (alignment > 1)
>  		region->mmap_size +=3D alignment;
> =20
> -	region->fd =3D -1;
> -	if (backing_src_is_shared(src_type))
> +	if (backing_src_is_guest_memfd(src_type))
> +		region->fd =3D guest_memfd;

This seems to cause a double-close in __vm_mem_region_delete() - it was
fine when this patch was written but now we have kvm_free_fd() which
crashes the test when this happens.

AFAICS it's easy to fix we just need to enlighten
__vm_mem_region_delete() that they might be the same FD.
