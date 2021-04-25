Return-Path: <SRS0=ELNw=JW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30E0C43460
	for <kvmarm@archiver.kernel.org>; Sun, 25 Apr 2021 10:30:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 56CAF613B3
	for <kvmarm@archiver.kernel.org>; Sun, 25 Apr 2021 10:30:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56CAF613B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E570A4B52B;
	Sun, 25 Apr 2021 06:30:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JxSsjwULNwjp; Sun, 25 Apr 2021 06:30:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8CF44B528;
	Sun, 25 Apr 2021 06:30:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 289134B31C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Apr 2021 03:52:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Eu4Vg9J2sB1J for <kvmarm@lists.cs.columbia.edu>;
 Sun, 25 Apr 2021 03:52:07 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A653D4B27C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Apr 2021 03:52:06 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FSgBy19Y2zNxMw;
 Sun, 25 Apr 2021 15:48:58 +0800 (CST)
Received: from [10.174.177.244] (10.174.177.244) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Sun, 25 Apr 2021 15:51:57 +0800
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
To: Mike Rapoport <rppt@kernel.org>
References: <20210421065108.1987-1-rppt@kernel.org>
 <9aa68d26-d736-3b75-4828-f148964eb7f0@huawei.com>
 <YIEl8aKr8Ly0Zd3O@kernel.org>
 <33fa74c2-f32d-f224-eb30-acdb717179ff@huawei.com>
 <2a1592ad-bc9d-4664-fd19-f7448a37edc0@huawei.com>
 <YIUYG8N9T3/C/tSG@kernel.org>
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <52f7d03b-7219-46bc-c62d-b976bc31ebd5@huawei.com>
Date: Sun, 25 Apr 2021 15:51:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YIUYG8N9T3/C/tSG@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.177.244]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Sun, 25 Apr 2021 06:30:41 -0400
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will
 Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2707660918335854593=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============2707660918335854593==
Content-Type: multipart/alternative;
	boundary="------------DED9ED8B6053C923FBA02074"
Content-Language: en-US

--------------DED9ED8B6053C923FBA02074
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit


On 2021/4/25 15:19, Mike Rapoport wrote:
> On Fri, Apr 23, 2021 at 04:11:16PM +0800, Kefeng Wang wrote:
>> I tested this patchset(plus arm32 change, like arm64 does) based on lts
>> 5.10，add
>>
>> some debug log, the useful info shows below, if we enable HOLES_IN_ZONE, no
>> panic,
>>
>> any idea, thanks.
>   
> Are there any changes on top of 5.10 except for pfn_valid() patch?
> Do you see this panic on 5.10 without the changes?

Yes, there are some BSP support for arm board based on 5.10, with or 
without

your patch will get same panic, the panic pfn=de600 in the range of 
[dcc00,de00]

which is freed by free_memmap, start_pfn = dcc00,  dcc00000 end_pfn = 
de700, de700000

we see the PC is at PageLRU, same reason like arm64 panic log,

"PageBuddy in move_freepages returns false Then we call PageLRU, the 
macro calls PF_HEAD which is compound_page() compound_page reads 
page->compound_head, it is 0xffffffffffffffff, so it resturns 
0xfffffffffffffffe - and accessing this address causes crash"

> Can you see stack backtrace beyond move_freepages_block?

I do some oom test, so the log is about memory allocate,

[<c02383c8>] (move_freepages_block) from [<c0238668>] 
(steal_suitable_fallback+0x174/0x1f4)

[<c0238668>] (steal_suitable_fallback) from [<c023999c>] 
(get_page_from_freelist+0x490/0x9a4)
[<c023999c>] (get_page_from_freelist) from [<c023a4dc>] 
(__alloc_pages_nodemask+0x188/0xc08)
[<c023a4dc>] (__alloc_pages_nodemask) from [<c0223078>] 
(alloc_zeroed_user_highpage_movable+0x14/0x3c)
[<c0223078>] (alloc_zeroed_user_highpage_movable) from [<c0226768>] 
(handle_mm_fault+0x254/0xac8)
[<c0226768>] (handle_mm_fault) from [<c04ba09c>] (do_page_fault+0x228/0x2f4)
[<c04ba09c>] (do_page_fault) from [<c0111d80>] (do_DataAbort+0x48/0xd0)
[<c0111d80>] (do_DataAbort) from [<c0100e00>] (__dabt_usr+0x40/0x60)
>
>> Zone ranges:
>>    Normal   [mem 0x0000000080a00000-0x00000000b01fffff]
>>    HighMem  [mem 0x00000000b0200000-0x00000000ffffefff]
>> Movable zone start for each node
>> Early memory node ranges
>>    node   0: [mem 0x0000000080a00000-0x00000000855fffff]
>>    node   0: [mem 0x0000000086a00000-0x0000000087dfffff]
>>    node   0: [mem 0x000000008bd00000-0x000000008c4fffff]
>>    node   0: [mem 0x000000008e300000-0x000000008ecfffff]
>>    node   0: [mem 0x0000000090d00000-0x00000000bfffffff]
>>    node   0: [mem 0x00000000cc000000-0x00000000dc9fffff]
>>    node   0: [mem 0x00000000de700000-0x00000000de9fffff]
>>    node   0: [mem 0x00000000e0800000-0x00000000e0bfffff]
>>    node   0: [mem 0x00000000f4b00000-0x00000000f6ffffff]
>>    node   0: [mem 0x00000000fda00000-0x00000000ffffefff]
>>
>> ----> free_memmap, start_pfn = 85800,  85800000 end_pfn = 86a00, 86a00000
>> ----> free_memmap, start_pfn = 8c800,  8c800000 end_pfn = 8e300, 8e300000
>> ----> free_memmap, start_pfn = 8f000,  8f000000 end_pfn = 90000, 90000000
>> ----> free_memmap, start_pfn = dcc00,  dcc00000 end_pfn = de700, de700000
>> ----> free_memmap, start_pfn = dec00,  dec00000 end_pfn = e0000, e0000000
>> ----> free_memmap, start_pfn = e0c00,  e0c00000 end_pfn = e4000, e4000000
>> ----> free_memmap, start_pfn = f7000,  f7000000 end_pfn = f8000, f8000000
>> === >move_freepages: start_pfn/end_pfn [de601, de7ff], [de600000, de7ff000]
>> :  pfn =de600 pfn2phy = de600000 , page = ef3cc000, page-flags = ffffffff
>> 8<--- cut here ---
>> Unable to handle kernel paging request at virtual address fffffffe
>> pgd = 5dd50df5
>> [fffffffe] *pgd=affff861, *pte=00000000, *ppte=00000000
>> Internal error: Oops: 37 [#1] SMP ARM
>> Modules linked in: gmac(O)
>> CPU: 2 PID: 635 Comm: test-oom Tainted: G           O      5.10.0+ #31
>> Hardware name: Hisilicon A9
>> PC is at move_freepages_block+0x150/0x278
>> LR is at move_freepages_block+0x150/0x278
>> pc : [<c02383a4>]    lr : [<c02383a4>]    psr: 200e0393
>> sp : c4179cf8  ip : 00000000  fp : 00000001
>> r10: c4179d58  r9 : 000de7ff  r8 : 00000000
>> r7 : c0863280  r6 : 000de600  r5 : 000de600  r4 : ef3cc000
>> r3 : ffffffff  r2 : 00000000  r1 : ef5d069c  r0 : fffffffe
>> Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
>> Control: 1ac5387d  Table: 83b0c04a  DAC: 55555555
>> Process test-oom (pid: 635, stack limit = 0x25d667df)
>>

--------------DED9ED8B6053C923FBA02074
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 2021/4/25 15:19, Mike Rapoport
      wrote:<br>
    </div>
    <blockquote type="cite" cite="mid:YIUYG8N9T3%2FC%2FtSG@kernel.org">
      <pre class="moz-quote-pre" wrap="">On Fri, Apr 23, 2021 at 04:11:16PM +0800, Kefeng Wang wrote:
</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">
I tested this patchset(plus arm32 change, like arm64 does) based on lts
5.10，add

some debug log, the useful info shows below, if we enable HOLES_IN_ZONE, no
panic,

any idea, thanks.
</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap=""> 
Are there any changes on top of 5.10 except for pfn_valid() patch?
Do you see this panic on 5.10 without the changes?</pre>
    </blockquote>
    <p>Yes, there are some BSP support for arm board based on 5.10, with
      or without <br>
    </p>
    <p>your patch will get same panic, the panic pfn=de600 in the range
      of [dcc00,de00]</p>
    <p>which is freed by free_memmap, start_pfn = dcc00,  dcc00000
      end_pfn = de700, de700000</p>
    <p>we see the PC is at PageLRU, same reason like arm64 panic log, <span
        class="q" style="font-size: 13px; font-family: monospace;">
      </span></p>
    <pre id="b" style="font-size: 13px; font-family: monospace; white-space: pre-wrap; color: rgb(0, 0, 0); font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;"><span class="q" style="font-size: 13px; font-family: monospace;">   "PageBuddy in move_freepages returns false
    Then we call PageLRU, the macro calls PF_HEAD which is compound_page()
    compound_page reads page-&gt;compound_head, it is 0xffffffffffffffff, so it
    resturns 0xfffffffffffffffe - and accessing this address causes crash"</span></pre>
    <blockquote type="cite" cite="mid:YIUYG8N9T3%2FC%2FtSG@kernel.org">
      <pre class="moz-quote-pre" wrap="">
Can you see stack backtrace beyond move_freepages_block?</pre>
    </blockquote>
    <p>I do some oom test, so the log is about memory allocate,<br>
    </p>
    <p>[&lt;c02383c8&gt;] (move_freepages_block) from [&lt;c0238668&gt;]
      (steal_suitable_fallback+0x174/0x1f4)</p>
    [&lt;c0238668&gt;] (steal_suitable_fallback) from [&lt;c023999c&gt;]
    (get_page_from_freelist+0x490/0x9a4)<br>
    [&lt;c023999c&gt;] (get_page_from_freelist) from [&lt;c023a4dc&gt;]
    (__alloc_pages_nodemask+0x188/0xc08)<br>
    [&lt;c023a4dc&gt;] (__alloc_pages_nodemask) from [&lt;c0223078&gt;]
    (alloc_zeroed_user_highpage_movable+0x14/0x3c)<br>
    [&lt;c0223078&gt;] (alloc_zeroed_user_highpage_movable) from
    [&lt;c0226768&gt;] (handle_mm_fault+0x254/0xac8)<br>
    [&lt;c0226768&gt;] (handle_mm_fault) from [&lt;c04ba09c&gt;]
    (do_page_fault+0x228/0x2f4)<br>
    [&lt;c04ba09c&gt;] (do_page_fault) from [&lt;c0111d80&gt;]
    (do_DataAbort+0x48/0xd0)<br>
    [&lt;c0111d80&gt;] (do_DataAbort) from [&lt;c0100e00&gt;]
    (__dabt_usr+0x40/0x60)<br>
    <blockquote type="cite" cite="mid:YIUYG8N9T3%2FC%2FtSG@kernel.org">
      <pre class="moz-quote-pre" wrap="">

</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">Zone ranges:
  Normal   [mem 0x0000000080a00000-0x00000000b01fffff]
  HighMem  [mem 0x00000000b0200000-0x00000000ffffefff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x0000000080a00000-0x00000000855fffff]
  node   0: [mem 0x0000000086a00000-0x0000000087dfffff]
  node   0: [mem 0x000000008bd00000-0x000000008c4fffff]
  node   0: [mem 0x000000008e300000-0x000000008ecfffff]
  node   0: [mem 0x0000000090d00000-0x00000000bfffffff]
  node   0: [mem 0x00000000cc000000-0x00000000dc9fffff]
  node   0: [mem 0x00000000de700000-0x00000000de9fffff]
  node   0: [mem 0x00000000e0800000-0x00000000e0bfffff]
  node   0: [mem 0x00000000f4b00000-0x00000000f6ffffff]
  node   0: [mem 0x00000000fda00000-0x00000000ffffefff]

----&gt; free_memmap, start_pfn = 85800,  85800000 end_pfn = 86a00, 86a00000
----&gt; free_memmap, start_pfn = 8c800,  8c800000 end_pfn = 8e300, 8e300000
----&gt; free_memmap, start_pfn = 8f000,  8f000000 end_pfn = 90000, 90000000
----&gt; free_memmap, start_pfn = dcc00,  dcc00000 end_pfn = de700, de700000
----&gt; free_memmap, start_pfn = dec00,  dec00000 end_pfn = e0000, e0000000
----&gt; free_memmap, start_pfn = e0c00,  e0c00000 end_pfn = e4000, e4000000
----&gt; free_memmap, start_pfn = f7000,  f7000000 end_pfn = f8000, f8000000
=== &gt;move_freepages: start_pfn/end_pfn [de601, de7ff], [de600000, de7ff000]
:  pfn =de600 pfn2phy = de600000 , page = ef3cc000, page-flags = ffffffff
8&lt;--- cut here ---
Unable to handle kernel paging request at virtual address fffffffe
pgd = 5dd50df5
[fffffffe] *pgd=affff861, *pte=00000000, *ppte=00000000
Internal error: Oops: 37 [#1] SMP ARM
Modules linked in: gmac(O)
CPU: 2 PID: 635 Comm: test-oom Tainted: G           O      5.10.0+ #31
Hardware name: Hisilicon A9
PC is at move_freepages_block+0x150/0x278
LR is at move_freepages_block+0x150/0x278
pc : [&lt;c02383a4&gt;]    lr : [&lt;c02383a4&gt;]    psr: 200e0393
sp : c4179cf8  ip : 00000000  fp : 00000001
r10: c4179d58  r9 : 000de7ff  r8 : 00000000
r7 : c0863280  r6 : 000de600  r5 : 000de600  r4 : ef3cc000
r3 : ffffffff  r2 : 00000000  r1 : ef5d069c  r0 : fffffffe
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 1ac5387d  Table: 83b0c04a  DAC: 55555555
Process test-oom (pid: 635, stack limit = 0x25d667df)

</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
</pre>
    </blockquote>
  </body>
</html>

--------------DED9ED8B6053C923FBA02074--

--===============2707660918335854593==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2707660918335854593==--
