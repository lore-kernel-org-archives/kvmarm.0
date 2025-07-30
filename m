Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEF0285CB0
	for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 11:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753875596; cv=none; b=c9DpDFKU5VIVfm3RMW5RzUosKBIdgSb8PxMjusmaAT2ZH9OjRp2veyIcJuatGdX8tfqdah2u8uhnhjyu2913J8zErn8mMtjOF7ClP7ztmwN39Vor8gVgb9l4118vy5kHaCbLEi9EHmYze3mQicsVypJ+eZiUfZFLzYPeR54ThWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753875596; c=relaxed/simple;
	bh=rb69SnQEKx+3Utl6hd4Gthucrbobnz6/4jOLOMshxJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tqbHlROWqv5ytq+FGFOR72By6EAn6p0XWapUxlTNM1+AVO7bJbwrIPwC5uba+U+C32b28bC9TvuY58UHZXh8xoeSKXBDgKa8SVak2RZFjlrsjT41ilNGop8icCyYozPFNTyeJ/ZaQoNePXH/C/sLZ9XkdiG9ES5dxWtJ2wWHfMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J+Oj47gf; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J+Oj47gf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753875595; x=1785411595;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rb69SnQEKx+3Utl6hd4Gthucrbobnz6/4jOLOMshxJg=;
  b=J+Oj47gfYVuCsZRgPGRUWxiM6DT/oNYymqIyc43CuDsKPbFyF3t8CJcf
   9HhO0UJLA9PO5ci5fZoRHfNpXzm1V49kGSLm9ZUlHc7PDkkYYVm9W+5ar
   5WCVrlA7c0PFgBN8/c6OMWsINCSbKEou4hsdjzOWWxGady4DJ3Zk+jHDj
   Up2qIV866kI7ZXgZiX8TOvcWorop5zWGy2tPXhxwWiFkopMbKyHkc6NsN
   ufLO7S8LnrTJmMHN0Dd//ISfpKo+gBFZPWY2RtiRAzxKzYkvpLJNdG2YU
   on9GuUUH/NfsnFdQ0URPNaZc9Ie1+tVS6XnIsSpNtNYVCwBPR+FD8XgV5
   A==;
X-CSE-ConnectionGUID: O2RTq21AS/6lpcgsZRY2QQ==
X-CSE-MsgGUID: N3Va8+wkQfavNx8nWmqYZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="56250726"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="56250726"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 04:39:54 -0700
X-CSE-ConnectionGUID: 6ybYhdAmQWCVdMvTeVI8Ug==
X-CSE-MsgGUID: zpy9UkLBTUGtQErhH87eRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="193807302"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 04:39:44 -0700
Message-ID: <856487d0-8e1a-4e64-a8e6-13977fd31fed@intel.com>
Date: Wed, 30 Jul 2025 19:39:41 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 23/24] KVM: selftests: guest_memfd mmap() test when
 mmap is supported
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>,
 Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>,
 David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>,
 Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>,
 James Houghton <jthoughton@google.com>
References: <20250729225455.670324-1-seanjc@google.com>
 <20250729225455.670324-24-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250729225455.670324-24-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/2025 6:54 AM, Sean Christopherson wrote:

...

> +int main(int argc, char *argv[])
> +{
> +	unsigned long vm_types, vm_type;
> +
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> +
> +	/*
> +	 * Not all architectures support KVM_CAP_VM_TYPES. However, those that
> +	 * support guest_memfd have that support for the default VM type.
> +	 */
> +	vm_types = kvm_check_cap(KVM_CAP_VM_TYPES);
> +	if (!vm_types)
> +		vm_types = VM_TYPE_DEFAULT;
> +
> +	for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
> +		test_guest_memfd(vm_type);

For ARCHes that don't support KVM_CAP_VM_TYPES, e.g., ARM, vm_types is 0 
(VM_TYPE_DEFAULT). the for_each_set_bit() loop will not execute any 
iteration at all.
