Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979462;
	b=W+i4I5qITBbnfpBX016W3KAzFsT2/I9fDZc5D8Y/4sFGuEn+JQdcWco31VWp57swXnBn
	 JCqrMar83+bKy7vXSviFnP3qgubIei1Ka/mFAoTAHSkoGhX5/Ka1J993FiIdq7zv2DBld
	 uVXeuXJfHOpL7WZLPs26I5iqjnuAVxWCVvjMcrVLh3Iq7JqL5M/8eiekYb0zUDxtFgVqL
	 1DwsrBqFPsq20QBqEJisaETsqpZgdJTAfh0MTz83mPqoJlXJQhg4mwkgsJFKTCb7/bmdV
	 9Tlj2FmqJoV6tP6RXnmy0Rf1m/mJoIdgD9A7HmbvtNbE266sI94gLcHt9hkHl+2UP3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979462;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=HuObySZLDxE9+LLAkaqrBSP5vceAa33bCHj1KNG2i7A=;
	b=JWcH6wqDZ/NzCC25165e/E6cuju2o7qgVSfKAN/boc71EuLuFeZ4yoCC30AZ1IYP7VUb
	 HEB4scrPTeHze/A21bpSdM6krpmQYsjBy5S5CycvyAqwMUF2FcyVJaDLKJLrM1zZ7qxKV
	 PawYcSQtAyd68Vlj3eO6UG44zAagINJrKpv+2vjzuzCLzwtuvti19N0ke/e36SESYB9PN
	 i+iaKxlVewH6buzVNjWdVxOQhvYQyxwZ/81n4pYZT5Fa7upTl6+d6wE9DPJX00wyAV4o4
	 KRlmldXMWY2nLGG8pa5KC2vXamtl9COYy/0FnSrpjQtZ1dScy8vw9n/j3dWgo8F71qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=llAlWz7x;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 094EF606D821
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 15:37:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 094EF606D821
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=llAlWz7x
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 475C81650;
	Fri,  6 Nov 2026 07:37:38 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 113BC3F632;
	Fri,  6 Nov 2026 07:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793979461; bh=qXWXkuBVBxZ9xT4eUDdfxaF2UuiBGoMjIIlVYYrkttg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=llAlWz7xlnBHxmmVTz87IEUBT+U3kyH9YObDETp6fosKhKB5oJhxN2dhuPXDLEEsX
	 DVL7yW5Oevy7iKyPxCGohG1kCXByNMZVwjct//ZIvQOmSyP2HF+mq413aZkhu0GgXL
	 wbI2QCexMI+/E09pwLD219X0IgawLZpU1REqS810=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	pbonzini@redhat.com,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	tangchengchang@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	fuad.tabba@linux.dev,
	mark.rutland@arm.com,
	seanjc@google.com,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v5 13/15] KVM: arm64: Add HDBSS buffer size ioctl for dirty-bitmap mode
Date: Fri,  6 Nov 2026 15:37:33 +0000
Message-ID: <au30PSHX_UBIIx_Y@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <5a096cca-713a-4449-83dc-c763dc06c085@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com> <20260929103655.85107-14-zhengtian10@huawei.com> <auioRICO9Frhk-zT@LeoBrasDK> <5a096cca-713a-4449-83dc-c763dc06c085@huawei.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Nov 06, 2026 at 06:27:27PM +0800, Tian Zheng wrote:
> 
> 
> On 11/2/2026 11:12 PM, Leonardo Bras wrote:
> > On Tue, Sep 29, 2026 at 06:36:53PM +0800, Tian Zheng wrote:
> > > In dirty-bitmap mode, a larger HDBSS buffer lets the guest dirty more
> > > pages between VM exits, at the cost of memory. The default of one page
> > > per vCPU is a reasonable starting point, so allow userspace to opt
> > > into a larger buffer via KVM_CAP_ARM_HDBSS_BUFFER_SIZE.
> > > 
> > > The size is specified in bytes through KVM_ENABLE_CAP and must be a
> > > power of two in [PAGE_SIZE, SZ_2M]: the upper bound is the largest
> > > HDBSSBR_EL2.SZ encoding, and the power-of-two requirement matches the
> > > buddy allocator. It must be set before any vCPU is created: -EINVAL
> > > after vCPUs exist, -EBUSY if already set.
> > > 
> > > The capability is rejected in dirty-ring mode, where the size is
> > > pinned by kvm_arch_dirty_ring_size_updated().
> > > 
> > > KVM_CHECK_EXTENSION returns the configured size for a VM, or SZ_2M
> > > when queried globally with a NULL kvm.
> > > 
> > > Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> > > ---
> > >   arch/arm64/kvm/arm.c     | 34 ++++++++++++++++++++++++++++++++++
> > >   include/uapi/linux/kvm.h |  1 +
> > >   2 files changed, 35 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 5a7046acb62e..eadbf3a88d31 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -19,6 +19,7 @@
> > >   #include <linux/kvm.h>
> > >   #include <linux/kvm_irqfd.h>
> > >   #include <linux/irqbypass.h>
> > > +#include <linux/log2.h>
> > >   #include <linux/sched/stat.h>
> > >   #include <linux/psci.h>
> > >   #include <trace/events/kvm.h>
> > > @@ -203,6 +204,31 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > >   		r = 0;
> > >   		set_bit(KVM_ARCH_FLAG_EXIT_SEA, &kvm->arch.flags);
> > >   		break;
> > > +	case KVM_CAP_ARM_HDBSS_BUFFER_SIZE: {
> > > +		u64 size = cap->args[0];
> > > +
> > > +		if (!system_supports_hdbss())
> > > +			break;
> > > +		if (kvm->dirty_ring_size)
> > > +			break;
> > > +		if (size < KVM_ARM_HDBSS_DEFAULT_SIZE ||
> > > +		    size > KVM_ARM_HDBSS_MAX_SIZE)
> > > +			break;
> > > +		if (!is_power_of_2(size))
> > > +			break;
> > > +
> > > +		mutex_lock(&kvm->lock);
> > > +		if (kvm->created_vcpus) {
> > > +			r = -EINVAL;
> > > +		} else if (kvm->arch.hdbss_buffer_size) {
> > > +			r = -EBUSY;
> > > +		} else {
> > > +			kvm->arch.hdbss_buffer_size = size;
> > > +			r = 0;
> > > +		}
> > > +		mutex_unlock(&kvm->lock);
> > > +		break;
> > > +	}
> > >   	default:
> > >   		break;
> > >   	}
> > > @@ -500,6 +526,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> > >   		else
> > >   			r = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> > >   		break;
> > > +	case KVM_CAP_ARM_HDBSS_BUFFER_SIZE:
> > > +		if (!system_supports_hdbss())
> > > +			r = 0;
> > > +		else if (kvm)
> > > +			r = kvm->arch.hdbss_buffer_size ?: KVM_ARM_HDBSS_DEFAULT_SIZE;
> > 
> > This whole thing of allowing hdbss_buf_size to be set only once makes
> > everything more complex. Why do we have this limitation again?
> > 
> > I mean, if we want to restrict size changes after the first hdbss buffer
> > gets allocated, it makes sense, other than that, I would like to understand
> > the reason for that.
> > 
> > Thanks!
> > Leo
> 
> Hi Leo,
> 
> You're right, I re-examined the whole flow and the "set once"
> restriction isn't actually needed. I'll remove it.
> 

Awesome, thanks!
Leo
