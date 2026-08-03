Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE4423BD1B;
	Mon,  3 Aug 2026 06:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785737204; cv=none; b=hozyzeXZ+xz/J3kDwa1ouYTOAsShMAUKInZxbDz5VC4PlerXopr0L0xxmO2Z0VQLWBdSJD3Zb+GeSRBujGxQCEr+m76aa9C4v6oUm4AF0GZkdSJ5S3wFrF61p7T7UdYP/HDczIhCrD3I+AccocqnjETM22scd6oXYEkv0M0aVsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785737204; c=relaxed/simple;
	bh=Ha/OCJxLeqBElIMxYRGxVg2lOqTvfhOZPdiRJwCcOnk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=o1nEP/XFfnwph9bDlrDFnwJJzWUvcfqAiMOkUs5yuhZoNz9kcbvgLqG4fXzSwkOMNoFgZIq3DGcIYC4MlOvYRqueRqivPvrk83H+QukT4Wm+XfSa86zrPIWvQxbBSv3XyUrey7bqDaN0sID8+5rhXgiiOiTtcF3WW2KiQ44zIX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QYpu7V/9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QYpu7V/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ED51F00A3A;
	Mon,  3 Aug 2026 06:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785737202;
	bh=xQ0u9RCRBxphehlJ1yHWTu9jZ9026hEwytYiN383DBo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=QYpu7V/9aoGGqVblJxfLdPmLPkto8elkoTJne92EFdDWcQY9QxnEISShMWCieWU0d
	 W4DPROsoZx0dKWlWL38m3Re+cz4JdItglud/RDmk8AHtzewRqBuvg1HzphOXbiWgMI
	 tkuj2w7hcPjQxABtASsu4UpY+d5wIamtu8eMIwFiJ12CftqniOiluWcuLCc8cbHpYJ
	 Jn3NIGIEyZQfZrttrSlC6BwuLQ0W3OMBkEu1YmzPG2mYdQc8zrgur/KhhRvtjjtpmL
	 SR+kcgKicCIW3PZFnMgGUknqQzl2wOnVAUE1YfbRkFSLdLwD5f/sKpw7Z7c2QpaMpY
	 l6zQNGigishCg==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>,
	Jack Thomson <jackabt.amazon@gmail.com>
Cc: maz@kernel.org, oupton@kernel.org, pbonzini@redhat.com,
	joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
	corbet@lwn.net, vladimir.murzin@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	isaku.yamahata@intel.com, Jack Thomson <jackabt@amazon.com>
Subject: Re: [PATCH v5 2/5] KVM: arm64: Add pre_fault_memory implementation
In-Reply-To: <alEXtW7w-rqlNG09@raptor>
References: <20260612162354.73378-1-jackabt.amazon@gmail.com>
 <20260612162354.73378-3-jackabt.amazon@gmail.com>
 <alEXtW7w-rqlNG09@raptor>
Date: Mon, 03 Aug 2026 11:36:33 +0530
Message-ID: <yq5acxvz4u1i.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Alexandru Elisei <alexandru.elisei@arm.com> writes:

> Hi Jack,
>
> On Fri, Jun 12, 2026 at 05:23:50PM +0100, Jack Thomson wrote:
>> From: Jack Thomson <jackabt@amazon.com>

....

>> +		if (kvm_is_error_hva(hva)) {
>> +			ret = -EFAULT;
>> +			goto out;
>> +		}
>> +
>> +		s2fd.hva = hva;
>> +		ret = user_mem_abort(&s2fd);
>
> If is_protected_kvm_enabled(), this function doesn't check if the mapping
> already exists. user_mem_abort() will call **p**kvm_pgtable_stage2_map()
> (emphasis is mine) to create the mapping, and pkvm_pgtable_stage2_map() will
> return -EAGAIN, and keep returning -EAGAIN until the mapping is destroyed, which
> might be some time away.
>
> Same thing happens **without** pKVM, kvm_pgtable_stage2_map() will return
> -EAGAIN if the mapping exists. But that's not such a big issue, when the
> user calls KVM_PRE_FAULT_MEMORY on the remaining range
> kvm_pgtable_get_leaf() will detect the existing mapping. Which you have
> already taken into consideration judging by the comment, so all good here.
>

But both gmem_abort() and user_mem_abort() handle -EAGAIN internally, don't they?

For gmem_abort(), we have:

1692:	return ret != -EAGAIN ? ret : 0;

For user_mem_abort(), the call path is:

user_mem_abort()
  -> kvm_s2_fault_map()
    -> KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, ...)

and kvm_s2_fault_map() does:

2111:	if (ret != -EAGAIN)
		return ret;
	return 0;

-aneesh
