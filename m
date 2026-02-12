Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E6A296BD2
	for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 11:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770897259; cv=none; b=Q78Fqhd9a/VOabBWErqCJZOY/pAbeA1ucs7USl6tOOPkk2HcV9c5maZPZeO+JtNhMwSpKH8cLEh/P6OV3D74ApOyLOBHHnmYKJDWe8SnviOU8yiDA94voE7etggRoqAHWoAnyDd76U8ADx5hZvU0BUzJeVXfl0fDCcwugUv+NUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770897259; c=relaxed/simple;
	bh=Et/OVf8SI5vk8Dev6/DtwQcZYZbBQFA56P6KGkBHBqU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=sHVKFkwaZ3NW2+EEYX9Zr7A9L5BHL2KAdDaKxqy3wSR6aosd15uv42ZZnCULKX+iCN6HHMPNItHmd/bEnyXgH6deHVWuOQ6RIypPFLiaWECThufi0hXP1QZk9QH6SrUphcULhZZOIOtiSkCGfvNtwaM8sDxOBXCqCQk60bsQEWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=gnInk9H2; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="gnInk9H2"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=yo+bKkpSB8SFQ41Jp/qa+TGhFgiev1U2fV/GrdV2qXU=;
	b=gnInk9H2sJVqPC1Jrb90dGaN41iBqUvxeFolKU3JbYEgxZkDOrC1Buh+9Y9+9p0KWYU5MKEY9
	S3VFL2ZjQvVffxhJJnlJ6P+AoRh/hTiPxqZyRgdwhAdl53QVTDBNQTH+cCGtDAfWVMbXitavUxg
	32SFnIzk/MxmOWG0r8nfLxE=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fBYWD0w8xzpSv2;
	Thu, 12 Feb 2026 19:49:44 +0800 (CST)
Received: from kwepemg500008.china.huawei.com (unknown [7.202.181.45])
	by mail.maildlp.com (Postfix) with ESMTPS id 025CE4056B;
	Thu, 12 Feb 2026 19:54:09 +0800 (CST)
Received: from kwepemj500003.china.huawei.com (7.202.194.33) by
 kwepemg500008.china.huawei.com (7.202.181.45) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 12 Feb 2026 19:54:08 +0800
Received: from kwepemj500003.china.huawei.com ([7.202.194.33]) by
 kwepemj500003.china.huawei.com ([7.202.194.33]) with mapi id 15.02.1544.011;
 Thu, 12 Feb 2026 19:54:08 +0800
From: "yezhenyu (A)" <yezhenyu2@huawei.com>
To: Marc Zyngier <maz@kernel.org>
CC: "rananta@google.com" <rananta@google.com>, "will@kernel.org"
	<will@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, zhengchuan <zhengchuan@huawei.com>,
	Xiexiangyou <xiexiangyou@huawei.com>, "guoqixin (A)" <guoqixin2@huawei.com>,
	"Mawen (Wayne)" <wayne.ma@huawei.com>
Subject: Re: [RFC][PATCH] arm64: tlb: call kvm_call_hyp once during
 kvm_tlb_flush_vmid_range
Thread-Topic: [RFC][PATCH] arm64: tlb: call kvm_call_hyp once during
 kvm_tlb_flush_vmid_range
Thread-Index: AdycFkT97SmLF28zTvuqoGutV5f5rw==
Date: Thu, 12 Feb 2026 11:54:08 +0000
Message-ID: <03e1ac99ccf04b7096f8d897226d75c1@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0



On 2026/2/9 22:35, Marc Zyngier wrote:
> On Mon, 09 Feb 2026 13:14:07 +0000,
> "yezhenyu (A)" <yezhenyu2@huawei.com> wrote:
>>
>>  From 9982be89f55bd99b3683337223284f0011ed248e Mon Sep 17 00:00:00 2001
>> From: eillon <yezhenyu2@huawei.com>
>> Date: Mon, 9 Feb 2026 19:48:46 +0800
>> Subject: [RFC][PATCH v1] arm64: tlb: call kvm_call_hyp once during
>>   kvm_tlb_flush_vmid_range
>>
>> The kvm_tlb_flush_vmid_range() function is performance-critical
>> during live migration, but there is a while loop when the system
>> support flush tlb by range when the size is larger than MAX_TLBI_RANGE_P=
AGES.
>>
>> This results in frequent entry to kvm_call_hyp() and then a large
>=20
> What is the cost of kvm_call_hyp()?

Most cost of kvm_tlb_flush_vmid_range() is __tlb_switch_to_host(), which
is called in every __kvm_tlb_flush_vmid/__kvm_tlb_flush_vmid_range.

>=20
>> amount of time is spent in kvm_clear_dirty_log_protect() during
>> migration(more than 50%).
>=20
> 50% of what time? The guest's run-time? The time spent doing TLBIs
> compared to the time spent in kvm_clear_dirty_log_protect()?
>=20

kvm_clear_dirty_log_protect() cost more than 50% time during=20
ram_find_and_save_block(), but not every time.
I captured the flame graph during the live migration, and the distribution
of several key functions is as follows(sorry I  cannot transfer the perf da=
ta
or the SVG files outside my company):

    ram_find_and_save_block(): 84.01%
        memory_region_clear_dirty_bitmap(): 33.40%
            kvm_clear_dirty_log_protect(): 26.74%
                kvm_arch_flush_remote_tlbs_range(): 9.67%
                    __tlb_switch_to_host(): 9.51%
                kvm_arch_mmu_enable_log_dirty_pt_masked(): 9.38%
        ram_save_target_page_legacy(): 43.41%

The memory_region_clear_dirty_bitmap() cost about 40% of
ram_find_and_save_block(), and the kvm_arch_flush_remote_tlbs_range()
cost about 29% of memory_region_clear_dirty_bitmap().

And after the patch apply, the distribution of several key functions is as =
follows:

    ram_find_and_save_block(): 53.84%
        memory_region_clear_dirty_bitmap(): 2.28%
            kvm_clear_dirty_log_protect(): 1.75%
                kvm_arch_flush_remote_tlbs_range(): 0.03%
                    __tlb_switch_to_host(): 0.03%
                kvm_arch_mmu_enable_log_dirty_pt_masked(): 0.96%
        ram_save_target_page_legacy(): 38.97%

The memory_region_clear_dirty_bitmap() cost about 4% of=20
ram_find_and_save_block(), and the kvm_arch_flush_remote_tlbs_range()
cost about 1% of memory_region_clear_dirty_bitmap().


>> So, when the address range is large than
>> MAX_TLBI_RANGE_PAGES, directly call __kvm_tlb_flush_vmid to
>> optimize performance.
>=20
> Multiple things here:
>=20
> - there is no SoB, which means that patch cannot be considered for
>    merging

If there are no other issues with this patch, I can resend it with the SoB =
(Signed-off-by) tag.

>=20
> - there is no data showing how this change improves the situation for
>    a large enough set of workloads
>=20
> - there is no description of a test that could be run on multiple
>    implementations to check whether this change has a positive or
>    negative impact
>=20

This patch affected the migration bandwidth during the live migration.
With the same physical bandwidth, the optimization effect of this patch
can be observed by monitoring the real live migration bandwidth.

I have test this in an RDMA-like environment, the physical bandwidth is
about 100GBps; without this patch, the migration bandwidth is below 10 GBps=
,
and after this patch apply, the migration bandwidth can reach 50 GBps.

> If you want to progress this sort of things, you will need to address
> these points.
>=20
> Thanks,
>=20
> 	M.
>
