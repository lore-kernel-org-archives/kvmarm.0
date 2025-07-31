Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C7CE55B
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 07:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753948179; cv=none; b=VIWwHD2B1pWws4X0VtF1Ccg8UTXX29QykWhoXC60vRpUQCF2d/p5NKRrjRI0/e67HbbEydtFeffqwL+8hMvIPzAUv1sojzP3VAXCVObGrKw353TdSaa8PllTazwQN7fD5+pFiM411mWDvwlf1QCMJzQMEh9Dh3lMqVNTgvtoFMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753948179; c=relaxed/simple;
	bh=Gs1MIGdx+aL/FvTa33b5/hEqyQZgikPYWC/APuQ9dlg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CzS2fOLw+3rXNiQkecvYSJ/h3gkcT1V878PshiRBQQWDTs/CvWulQPGygfAbDyBchunRPH13PqJ72dolSSAxxpFKSTWnxRrZ2gI2omvBHZVPeL1NlNV4aa556NUr2pLQ76md0+NUrUy+C7cr0AzMH49XkjMSy72Jbvx7de8nc6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H4zfgFFI; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H4zfgFFI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753948177; x=1785484177;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Gs1MIGdx+aL/FvTa33b5/hEqyQZgikPYWC/APuQ9dlg=;
  b=H4zfgFFIofogbNiFZpqULllfc6ZN0UYSC5SWI7lMaX+SietFUCenDzQk
   uwCZCQ3B4eHMkgQeLC1eHMESigf0QBMv86BKI+tx0HNSYNU68tlTFaGAr
   Pq7jxhECkDr3b/RTAhwxyK4nihVQdp/CZcMGZDNVIZ+o3EoJ8VBTIuRLO
   I5awOaWEf7PQnTeq6xsWlOFgyodw5Fx4zmKpg/XiQ/7Dzk51eMSBn5/Gz
   8uvUTQ3gqWn74sccDm6vLvZLFTEQzO2rGwvUTxTNF7VRA5vG9sNrewx/6
   2h4DUSjv7UnyEV3HMt23J5LPT5kyCNJ1IZpH4H+2Ki8iS1+tJ+xvJRVo/
   A==;
X-CSE-ConnectionGUID: VLcRuVjtRiORWUqtAwN95A==
X-CSE-MsgGUID: UptL3j3tSaWskRimkHZrww==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="56340252"
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="56340252"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 00:49:37 -0700
X-CSE-ConnectionGUID: 73cEAW53RymL+KeNij9jPQ==
X-CSE-MsgGUID: my5o4r9WSBaok3whtlcfJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="163541810"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 00:49:33 -0700
Message-ID: <44f17b93-cf3c-43e9-b921-5f904c13db69@intel.com>
Date: Thu, 31 Jul 2025 15:49:29 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 23/24] KVM: selftests: guest_memfd mmap() test when
 mmap is supported
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>,
 Fuad Tabba <tabba@google.com>, Ackerley Tng <ackerleytng@google.com>,
 Tao Chan <chentao@kylinos.cn>, James Houghton <jthoughton@google.com>
References: <20250729225455.670324-1-seanjc@google.com>
 <20250729225455.670324-24-seanjc@google.com>
 <856487d0-8e1a-4e64-a8e6-13977fd31fed@intel.com>
 <aIoWosN3UiPe2qQK@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aIoWosN3UiPe2qQK@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/2025 8:57 PM, Sean Christopherson wrote:
> On Wed, Jul 30, 2025, Xiaoyao Li wrote:
>> On 7/30/2025 6:54 AM, Sean Christopherson wrote:
>>
>> ...
>>
>>> +int main(int argc, char *argv[])
>>> +{
>>> +	unsigned long vm_types, vm_type;
>>> +
>>> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
>>> +
>>> +	/*
>>> +	 * Not all architectures support KVM_CAP_VM_TYPES. However, those that
>>> +	 * support guest_memfd have that support for the default VM type.
>>> +	 */
>>> +	vm_types = kvm_check_cap(KVM_CAP_VM_TYPES);
>>> +	if (!vm_types)
>>> +		vm_types = VM_TYPE_DEFAULT;
>>> +
>>> +	for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
>>> +		test_guest_memfd(vm_type);
>>
>> For ARCHes that don't support KVM_CAP_VM_TYPES, e.g., ARM, vm_types is 0
>> (VM_TYPE_DEFAULT). the for_each_set_bit() loop will not execute any
>> iteration at all.
> 
> Doh, indeed.
> 
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index b86bf89a71e0..b3ca6737f304 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -372,7 +372,7 @@ int main(int argc, char *argv[])
>           */
>          vm_types = kvm_check_cap(KVM_CAP_VM_TYPES);
>          if (!vm_types)
> -               vm_types = VM_TYPE_DEFAULT;
> +               vm_types = BIT(VM_TYPE_DEFAULT);
>   
>          for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
>                  test_guest_memfd(vm_type);

With the above fix,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
