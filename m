Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0607146D096
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 12:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787057366; cv=none; b=OOyNxsaigQMQ0iP94ZRXX7Y74UyzWPjhkVRDJil2PfHKdp1ml80AXbEFiFzzyVvxQzBSUlpYyPWIx/GFFYkKeAigg5qEpcqQBGi2U70MCmEYBiWWVZ44k3I06CDaK4knrnFedo2+qlrfw/6O9mSIgFyofVSmEANfYkXlbLkYd+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787057366; c=relaxed/simple;
	bh=cvR0dWZUF4em4CAcfZS1ifgyPX19BMD2dQHLEiiqibQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W8kNyVzaFwY6oaP5RyuD4BVNbsA5JdL1KEdwS16WwUGYiX7wci8AhddIj4UuLPVFy4McJFUNNx1X079CwVHCovM0Jz6hr4at5mOV1J06yBTKhs+UtnWBUZEg8XMi+DV0yXSD6FBX+eNL31ZOhD9TVKwg/hlyAAzpSpqw2Sywt7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QSFob4Jl; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QSFob4Jl"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38ea87caafeso3564126a91.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 05:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787057364; x=1787662164; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g8KO6swaxgVTtcdM/0ToN4cGodRQ27jC6GnsdjaTcjE=;
        b=QSFob4JllBCbNbgRrbC0N8SXTkmDbNWTnttSfypC+/fyTTpvBi7SFVlQp4M2gC+2z3
         A1IyXl4rYRplcsrDlwddSAEUX+sLIvSJJyKVpMuN8MvH58Tjdr85fi6i8SC16eBlthd3
         TEbJWcsdBA/f5MApoC1bHbrIpt3i+reb/NrgxJNV9SSb+udYuuy+w+PqOrR3XxX7ynPh
         WMmEuCD8kJVgmU2F8YffO/7OeYeC9Ve1GognevXkahJJ0R4i4CzJDb29o/GZGLKKWFqd
         +osYdJW7ByV3p7PDkhFz4hbv8FUglZdfgQfmPAHqlQOZAWdgVmpegD7/QvBj2JkW5Xvd
         BdrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787057364; x=1787662164;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g8KO6swaxgVTtcdM/0ToN4cGodRQ27jC6GnsdjaTcjE=;
        b=a4LjNgGsodU4WzFSgbM3gQpBNuu1gu0ql1XNxB3wM4W5iMCq251+tJ4r4WcVfMZ4Hp
         g42aIhMUOH6rxpZzIbno+83Kq5FBCaAqDQotbD708wVi3bAim6KAEHYsP4ElMgx3azeD
         sMKxL8ep0spbrSV/4AF0PrgEaoKgncu8Fr5WduzO0bIXLnFsdDd4PCzjDjez98ag6UNT
         yVTQsBKKgXkDlh7tg5EwNffwR/W5dqMblRYKMPJAATRi4f4OSMQVGHKNThgMPwWShB3n
         Q9OtC/7ok2n+CxXRHCF+waFp1Fci6WY3bJNqWcHhGmu+HGYLyoheZxAuzaiWOsQVOTvi
         HkTA==
X-Gm-Message-State: AOJu0YznfTR8nTNgxIgnW522Kxqu51nl6jGjyf9CklJJ19JKTM5WwQKp
	uyrUKJamZHq3/1V7cjny9CF5dtOJgaYpkmnoh7TjUjrcIYEVW1Cq0LbD
X-Gm-Gg: AR+sD13OwlpxYQ8dhlaciI8wSO/8JHzcUA1Cl4DTcpt57vo6jxiBnbLRuR5ptahTp66
	psbBG0l2mbZT9jZEtO6xmZAv3c7DIXMXsvlWXqB22LFIzK3t6JhykvI4M8dGVu0L1L+J5qhMDZb
	ZAAJV/rPXm7Pl/UE0/6wIHM/vLf4hNznQdvAdIi5eyWClxRY5DzYCkVUvUBDBI4sKIv+C54idvG
	eMxQ3fbjRMvdMHNcm3IF20jO9rkyVLyNV/hPLDOCzEHxpUZZ3ip4EEaz74u+nP6Np019813sPvS
	VuydrBXXbEgm9a6kcxBIb3ZH/E+XTZDVgdfybhsLNcSBQy1e8KIzMXKvKdarjui05p2rhs0Qz1t
	egqd1lDljDLK2qOc/Ud/JnvRIz7v1bCa4b/TbeReVKo4kLSB1Hh6TXtrL/LGt61A8pV+wVSv2DV
	/VbsGnm/eOJN+U8HMnZBfYihl+18k/e+Bk12CAuWFucnM15iriUESqzxFCDSJzppqC2dZ5Dq/lP
	w5p4Ns2iB5XEXS23U3ji1GJJS8=
X-Received: by 2002:a17:90b:264c:b0:38d:ddc2:7ccb with SMTP id 98e67ed59e1d1-3933b714f34mr36446357a91.1.1787057364363;
        Tue, 18 Aug 2026 05:49:24 -0700 (PDT)
Received: from [10.26.143.42] ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39339d00eafsm7174764a91.1.2026.08.18.05.49.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 05:49:24 -0700 (PDT)
Message-ID: <4f7023b4-dd7a-47cb-9754-52e6d41d3aa1@gmail.com>
Date: Tue, 18 Aug 2026 20:49:21 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] KVM: selftests: arm64: Skip sea_to_user without
 1GB hugepages
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
 kvm@vger.kernel.org, sashiko-reviews@lists.linux.dev
References: <20260818112920.26252-1-likexu@tencent.com>
 <20260818112920.26252-3-likexu@tencent.com>
 <20260818113615.5CBE01F000E9@smtp.kernel.org>
Content-Language: en-US
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20260818113615.5CBE01F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/26 7:36 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] get_free_hugepages() overestimates available hugepages by ignoring reserved pages, which allows the test to proceed and crash with ENOMEM on systems with reserved pools.
> --
> 
> --- Patch [2]: [PATCH v2 2/3] KVM: selftests: arm64: Skip sea_to_user without 1GB hugepages ---
> commit 5fa5666824342b3dd28a5ef6a04bb5ac183257c8
> Author: Like Xu <like.xu.linux@gmail.com>
> 
> KVM: selftests: arm64: Skip sea_to_user without 1GB hugepages
> 
> This commit adds a check to skip the sea_to_user test if the host does not
> have enough 1GB hugepages available, preventing a hard failure on systems
> without an empty pool.
> 
> [ ... ]
>> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
>> index bab1bd2b775b6..29f9c1d60b1b7 100644
>> --- a/tools/testing/selftests/kvm/lib/test_util.c
>> +++ b/tools/testing/selftests/kvm/lib/test_util.c
>> @@ -222,6 +222,21 @@ size_t get_def_hugetlb_pagesz(void)
>>   	TEST_FAIL("Error in reading /proc/meminfo");
>>   }
>>   
>> +size_t get_free_hugepages(size_t page_size)
>> +{
>> +	char path[128];
>> +	size_t free;
>> +
>> +	snprintf(path, sizeof(path),
>> +		 "/sys/kernel/mm/hugepages/hugepages-%zukB/free_hugepages",
>> +		 page_size >> 10);
>> +	if (!test_sysfs_path(path))
>> +		return 0;
>> +
>> +	free = get_sysfs_val(path);
>> +	return free * page_size;
> 
> [Severity: Medium]
> Does this calculation overestimate the available hugepages by ignoring the
> reserved pool?
> 
> The sysfs free_hugepages value includes pages that are already committed to
> other mappings but not yet allocated (which are tracked via resv_hugepages).
> 
> If the test runs on a host where free_hugepages meets the VM_MEM_SIZE
> requirement but some or all of those pages are reserved, the test will
> incorrectly proceed and still crash with an -ENOMEM abort instead of cleanly
> skipping.
> 
> Could we also read and subtract resv_hugepages to determine the actual
> allocatable count?

For any human to double check:

diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c 
b/tools/testing/selftests/kvm/arm64/sea_to_user.c
index 1c2a743ca8e23..7cf95da8e594d 100644
--- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
+++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
@@ -281,6 +281,12 @@ static struct kvm_vm 
*vm_create_with_sea_handler(struct kvm_vcpu **vcpu)
  	alignment = max(backing_page_size, guest_page_size);
  	num_guest_pages = VM_MEM_SIZE / guest_page_size;

+	/*
+	 * The region is backed by 1GB hugepages; skip gracefully rather than
+	 * failing with mmap() -ENOMEM if the host has none reserved.
+	 */
+	TEST_REQUIRE(get_free_hugepages(backing_page_size) >= VM_MEM_SIZE);
+
  	vm = __vm_create_with_one_vcpu(vcpu, num_guest_pages, guest_code);
  	vm_init_descriptor_tables(vm);
  	vcpu_init_descriptor_tables(*vcpu);
diff --git a/tools/testing/selftests/kvm/include/test_util.h 
b/tools/testing/selftests/kvm/include/test_util.h
index a56271c237ae9..0624922c2735d 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -168,6 +168,7 @@ struct vm_mem_backing_src_alias {
  bool thp_configured(void);
  size_t get_trans_hugepagesz(void);
  size_t get_def_hugetlb_pagesz(void);
+size_t get_free_hugepages(size_t page_size);
  const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(u32 i);
  size_t get_backing_src_pagesz(u32 i);
  bool is_backing_src_hugetlb(u32 i);
diff --git a/tools/testing/selftests/kvm/lib/test_util.c 
b/tools/testing/selftests/kvm/lib/test_util.c
index bab1bd2b775b6..3bff9d825e8af 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -222,6 +222,32 @@ size_t get_def_hugetlb_pagesz(void)
  	TEST_FAIL("Error in reading /proc/meminfo");
  }

+size_t get_free_hugepages(size_t page_size)
+{
+	char path[128];
+	size_t free, resv;
+
+	snprintf(path, sizeof(path),
+		 "/sys/kernel/mm/hugepages/hugepages-%zukB/free_hugepages",
+		 page_size >> 10);
+	if (!test_sysfs_path(path))
+		return 0;
+	free = get_sysfs_val(path);
+
+	/*
+	 * free_hugepages still counts pages that are reserved by existing
+	 * mappings but not yet faulted in, so only free minus resv can back a
+	 * new reservation (see available_huge_pages() in mm/hugetlb.c). Ignore
+	 * surplus/overcommit: it does not apply to gigantic pages at runtime.
+	 */
+	snprintf(path, sizeof(path),
+		 "/sys/kernel/mm/hugepages/hugepages-%zukB/resv_hugepages",
+		 page_size >> 10);
+	resv = test_sysfs_path(path) ? get_sysfs_val(path) : 0;
+
+	return free > resv ? (free - resv) * page_size : 0;
+}
+
  #define ANON_FLAGS	(MAP_PRIVATE | MAP_ANONYMOUS)
  #define ANON_HUGE_FLAGS	(ANON_FLAGS | MAP_HUGETLB)

> 
>> +}
>> +
>>   #define ANON_FLAGS	(MAP_PRIVATE | MAP_ANONYMOUS)
>>   #define ANON_HUGE_FLAGS	(ANON_FLAGS | MAP_HUGETLB)
>>
> 

