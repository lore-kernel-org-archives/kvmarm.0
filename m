Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DC92D7398
	for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 07:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778570909; cv=none; b=OVPC0B3GWaOjoBNO9jHZ/RoxsZnvtMQ0k6gK+z3oIy9nGPu9AyMtZCPgg4uLWlfLusyXx9bbLbqRJiAMDa5YtS8iaJjtYMbzJZFEtnQq/So6enrGnGzEcs024n3c6hN32AhKM4e/IApYqLahOViYFFWNyAVKytSZ+3QDhl7vwjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778570909; c=relaxed/simple;
	bh=BF1h7d3QFH3gs3GCJRmEVg8aCTgCY+D4Jfh7Gj1jblo=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Da2xqiTMeaP2Fzyxw7PUCR2Q3YlYfyT6S3atIlJVkRrwwMZJhWa7eE9LLNW7tq2FI8+Xph0txGAaHMDzpfl6ZnC0Stwt+gcMEYmE+zAML+wcYwVCUNx+tGJ1mXoPnFmuAmrIjv26gMe3+9uX6/GOR0GEM0sMBgcpTFDTeHSZLg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=jDz5xt+7; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="jDz5xt+7"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0nYwTUDHswJFeRsm/3KU6Cy6V8aaaXNHXn0IsdxK2KM=;
	b=jDz5xt+7E9Lxfqur4EwzYh7d4J68ycyVgDFhfjX+3kufj3THHFvpmx0rAgUJs7I3IvBvS/xhN
	kRmNigPk/3bor01beAWpkIif/AtEHZ2SkATpOewgHbf9yewe0lajQKkW0+LLDeh9Udesbzl1aZw
	0kHXJRz4zkGulG4lwkrqlWc=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gF7Kk28hxz1K96d;
	Tue, 12 May 2026 15:20:42 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id 5A6B34056E;
	Tue, 12 May 2026 15:28:17 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 12 May 2026 15:28:16 +0800
Subject: Re: [PATCH v17 24/24] KVM: selftests: Add guest_memfd testcase to
 fault-in on !mmap()'d memory
To: Sean Christopherson <seanjc@google.com>
CC: Zenghui Yu <zenghui.yu@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Ira Weiny
	<ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg
	<shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li
	<xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, Fuad Tabba
	<tabba@google.com>, Ackerley Tng <ackerleytng@google.com>, Tao Chan
	<chentao@kylinos.cn>, James Houghton <jthoughton@google.com>
References: <20250729225455.670324-1-seanjc@google.com>
 <20250729225455.670324-25-seanjc@google.com>
 <0064952b-048c-455d-ad89-e27e5cb82591@linux.dev>
 <aeJkCGwsrRmuBikT@google.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <c17d864a-42fc-afbe-345e-c728e2735d0c@huawei.com>
Date: Tue, 12 May 2026 15:28:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <aeJkCGwsrRmuBikT@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk200017.china.huawei.com (7.202.194.83)

Hi Sean,

On 2026/4/18 0:47, Sean Christopherson wrote:
> 
> Does this fix things for you?  If so, I'll send a proper patch.
> 
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index ec7644aae999..c682bda722f9 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -510,9 +510,15 @@ static void test_guest_memfd_guest(void)
>                     "Default VM type should support INIT_SHARED, supported flags = 0x%x",
>                     vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS));
>  
> +       /*
> +        * Use the guest's page size for all accesses, e.g. to avoid having to
> +        * map multiple pages, but create the guest_memfd instance with the max
> +        * of the host or guest page size, as KVM requires gmem files to be
> +        * aligned to the host page size.
> +        */
>         size = vm->page_size;
> -       fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP |
> -                                            GUEST_MEMFD_FLAG_INIT_SHARED);
> +       fd = vm_create_guest_memfd(vm, max(size, page_size), GUEST_MEMFD_FLAG_MMAP |
> +                                                            GUEST_MEMFD_FLAG_INIT_SHARED);
>         vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL, fd, 0);
>  
>         mem = kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);

This results in another failure at

|	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size,
NULL, fd, 0);

# ./guest_memfd_test
Random seed: 0x6b8b4567
__vm_create: mode='PA-bits:40,  VA-bits:48,  4K pages' type='0', pages='672'
==== Test Assertion Failure ====
  lib/kvm_util.c:974: !ret
  pid=284539 tid=284539 errno=22 - Invalid argument
     1	0x00000000004008fb: test_guest_memfd_guest at guest_memfd_test.c:522
     2	 (inlined by) main at guest_memfd_test.c:561
     3	0x0000000000417623: __libc_start_call_main at libc-start.o:?
     4	0x000000000041796b: __libc_start_main_impl at ??:?
     5	0x0000000000400cef: _start at ??:?
  KVM_SET_USER_MEMORY_REGION2 failed, errno = 22 (Invalid argument)

Thanks,
Zenghui
