Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A17C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 07:34:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D798761936
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 07:34:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D798761936
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A57D4B75B;
	Wed, 12 May 2021 03:34:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ibm.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ORPs4XbqEBSH; Wed, 12 May 2021 03:34:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA6164B485;
	Wed, 12 May 2021 03:34:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E89974B485
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 03:34:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MjQRVcUlvFkC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 03:34:14 -0400 (EDT)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E48914B42D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 03:34:13 -0400 (EDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
 14C7XgkA116740; Wed, 12 May 2021 03:34:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=8RxozYUmHbciTCPsdI2xx6ZwNkaTrcx5gcPNgxcEk0o=;
 b=TpIdg57MewPAG1xmXJIUB4b4YMeBjcW7/XLoBr8wDlySdF5Gbvlnnu+pRxFVdJUExj4I
 othCsnCAM0rVf5IRNBPRNvNHsXd/bOIB+entalPvJ/KZDKFtsfME9hEsUTtGOJlMXn9f
 CyXuIE8x/00Vo48bPBBfKD25WhJFX9i9fgkqHWLGWTcu2lUYogQnjHwpmkbDfe4Pzmmh
 VLW7ADm6ERGhSKoYGo9Qxt0H9D9QSl8r7S9pBTfVqfN7eZYsm6fEkvVTRV/RwFVxHFeE
 AceoVQU/tVcf+EbqkhefksYwcvajvRsvGAOKSFNW5HuqNQaAd+Lo7EDAQkI/IXI3jz7j mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com with ESMTP id 38ga7f8vmu-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Wed, 12 May 2021 03:34:05 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
 by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14C7XqNE117366;
 Wed, 12 May 2021 03:34:05 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com
 [159.122.73.71])
 by mx0a-001b2d01.pphosted.com with ESMTP id 38ga7f8vky-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Wed, 12 May 2021 03:34:04 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
 by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14C7X9fZ001985;
 Wed, 12 May 2021 07:34:02 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com
 (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
 by ppma02fra.de.ibm.com with ESMTP id 38dj9893pu-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Wed, 12 May 2021 07:34:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com
 [9.149.105.62])
 by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP
 id 14C7XX2K28442910
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 12 May 2021 07:33:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 15AF2AE055;
 Wed, 12 May 2021 07:34:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 9BC2CAE04D;
 Wed, 12 May 2021 07:33:58 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.39.4])
 by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
 Wed, 12 May 2021 07:33:58 +0000 (GMT)
Date: Wed, 12 May 2021 10:33:56 +0300
From: Mike Rapoport <rppt@linux.ibm.com>
To: Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 0/4] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
Message-ID: <YJuE5O8nWNc1TGZ6@linux.ibm.com>
References: <20210511100550.28178-1-rppt@kernel.org>
 <CAMj1kXFHLkmgZKEb8BtgGt6GQ93Qd+yv6NtiCvtgX0ex9wSeyw@mail.gmail.com>
Content-Disposition: inline
In-Reply-To: <CAMj1kXFHLkmgZKEb8BtgGt6GQ93Qd+yv6NtiCvtgX0ex9wSeyw@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xaFvPDmB3qDdufrQ1oVBdCcS20frTO-N
X-Proofpoint-ORIG-GUID: H5s5JzP0-t3y1SHp24KJ228bqWiUmp9w
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391, 18.0.761
 definitions=2021-05-12_03:2021-05-11,
 2021-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 clxscore=1011 suspectscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105120053
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
 Mike Rapoport <rppt@kernel.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, May 12, 2021 at 09:00:02AM +0200, Ard Biesheuvel wrote:
> On Tue, 11 May 2021 at 12:05, Mike Rapoport <rppt@kernel.org> wrote:
> >
> > From: Mike Rapoport <rppt@linux.ibm.com>
> >
> > Hi,
> >
> > These patches aim to remove CONFIG_HOLES_IN_ZONE and essentially hardwire
> > pfn_valid_within() to 1.
> >
> > The idea is to mark NOMAP pages as reserved in the memory map and restore
> > the intended semantics of pfn_valid() to designate availability of struct
> > page for a pfn.
> >
> > With this the core mm will be able to cope with the fact that it cannot use
> > NOMAP pages and the holes created by NOMAP ranges within MAX_ORDER blocks
> > will be treated correctly even without the need for pfn_valid_within.
> >
> > The patches are boot tested on qemu-system-aarch64.
> >
> 
> Did you use EFI boot when testing this? The memory map is much more
> fragmented in that case, so this would be a good data point.

Right, something like this:

[    0.000000] Early memory node ranges                                         
[    0.000000]   node   0: [mem 0x0000000040000000-0x00000000ffffbfff]          
[    0.000000]   node   0: [mem 0x00000000ffffc000-0x00000000ffffffff]          
[    0.000000]   node   0: [mem 0x0000000100000000-0x00000004386fffff]          
[    0.000000]   node   0: [mem 0x0000000438700000-0x000000043899ffff]          
[    0.000000]   node   0: [mem 0x00000004389a0000-0x00000004389bffff]          
[    0.000000]   node   0: [mem 0x00000004389c0000-0x0000000438b5ffff]          
[    0.000000]   node   0: [mem 0x0000000438b60000-0x000000043be3ffff]          
[    0.000000]   node   0: [mem 0x000000043be40000-0x000000043becffff]          
[    0.000000]   node   0: [mem 0x000000043bed0000-0x000000043bedffff]          
[    0.000000]   node   0: [mem 0x000000043bee0000-0x000000043bffffff]          
[    0.000000]   node   0: [mem 0x000000043c000000-0x000000043fffffff]          

This is a pity really, because I don't see a fundamental reason for those
tiny holes all over the place. 

I know that EFI/ACPI mandates "IO style" memory access for those regions,
but I fail to get why...
 
> > I beleive it would be best to route these via mmotm tree.
> >
> > v4:
> > * rebase on v5.13-rc1
> >
> > v3: Link: https://lore.kernel.org/lkml/20210422061902.21614-1-rppt@kernel.org
> > * Fix minor issues found by Anshuman
> > * Freshen up the declaration of pfn_valid() to make it consistent with
> >   pfn_is_map_memory()
> > * Add more Acked-by and Reviewed-by tags, thanks Anshuman and David
> >
> > v2: Link: https://lore.kernel.org/lkml/20210421065108.1987-1-rppt@kernel.org
> > * Add check for PFN overflow in pfn_is_map_memory()
> > * Add Acked-by and Reviewed-by tags, thanks David.
> >
> > v1: Link: https://lore.kernel.org/lkml/20210420090925.7457-1-rppt@kernel.org
> > * Add comment about the semantics of pfn_valid() as Anshuman suggested
> > * Extend comments about MEMBLOCK_NOMAP, per Anshuman
> > * Use pfn_is_map_memory() name for the exported wrapper for
> >   memblock_is_map_memory(). It is still local to arch/arm64 in the end
> >   because of header dependency issues.
> >
> > rfc: Link: https://lore.kernel.org/lkml/20210407172607.8812-1-rppt@kernel.org
> >
> > Mike Rapoport (4):
> >   include/linux/mmzone.h: add documentation for pfn_valid()
> >   memblock: update initialization of reserved pages
> >   arm64: decouple check whether pfn is in linear map from pfn_valid()
> >   arm64: drop pfn_valid_within() and simplify pfn_valid()
> >
> >  arch/arm64/Kconfig              |  3 ---
> >  arch/arm64/include/asm/memory.h |  2 +-
> >  arch/arm64/include/asm/page.h   |  3 ++-
> >  arch/arm64/kvm/mmu.c            |  2 +-
> >  arch/arm64/mm/init.c            | 14 +++++++++++++-
> >  arch/arm64/mm/ioremap.c         |  4 ++--
> >  arch/arm64/mm/mmu.c             |  2 +-
> >  include/linux/memblock.h        |  4 +++-
> >  include/linux/mmzone.h          | 11 +++++++++++
> >  mm/memblock.c                   | 28 ++++++++++++++++++++++++++--
> >  10 files changed, 60 insertions(+), 13 deletions(-)
> >
> >
> > base-commit: 6efb943b8616ec53a5e444193dccf1af9ad627b5
> > --
> > 2.28.0
> >

-- 
Sincerely yours,
Mike.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
