Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A271D5ABD
	for <kvmarm@lists.linux.dev>; Wed, 25 Sep 2024 15:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727278881; cv=none; b=PF0dh4LG0MtrhTDZtYhSrtcDYDB54aoY3+DB53iwKhWFsHwoQt1VsGzqFPCQ4lQySs60gkdU72AvycYqF78zGOAH17pdCuhrYczATnZXJyBkZ2NNRoKRvJ0eLmg4dTXSjtoIoB/XkIrD6qg8+Hp0eTd5yKMGW89aQDLOBTyWnwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727278881; c=relaxed/simple;
	bh=XdIiP8QBavfMPgjp8RGBjGQ1EnwyjLA9PTXezUXK+sM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HqGFPv0jkgbqtf1hc1bru3CoPqLf5J5YEGHo13HP/5v1aO+J3yGKNbgoebDIO1KT9ntMI3d1GHJTYNeSgAx4EQeZwmzXSX7tUUCJ2DFWCrV3KUn8mnsH9NKjHIan+INGQRZ/4p/OIWw4+B1+W2TiqUJN4GnB8R4aGeJRoxmeYFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=Yf1hxXlz; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="Yf1hxXlz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1727278879; x=1758814879;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w3ztpLhKheiGL86VzRoyFegLW0y8yDiy4GWDc/IATVw=;
  b=Yf1hxXlzHW6mH7WEQEWm8CMe2+fu3DsrWSXgKTFqJtwmZ55Fo3Rmx6YS
   TAFEI8p9c3/QZP/A7WBR0HsgDDEZnr+aN3dfSwFhkTchutp5n6ct9Pd2R
   HctS9CxUNpSq+6EqFQM9fZkj95jAEomivn6+p/evEro/nTklfVmRHh33o
   Y=;
X-IronPort-AV: E=Sophos;i="6.10,257,1719878400"; 
   d="scan'208";a="335009767"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2024 15:41:01 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.17.79:26531]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.17.12:2525] with esmtp (Farcaster)
 id e0ffb752-46f6-4514-b306-44d8338eba99; Wed, 25 Sep 2024 15:40:59 +0000 (UTC)
X-Farcaster-Flow-ID: e0ffb752-46f6-4514-b306-44d8338eba99
Received: from EX19D007EUA001.ant.amazon.com (10.252.50.133) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 25 Sep 2024 15:40:59 +0000
Received: from EX19MTAUWA002.ant.amazon.com (10.250.64.202) by
 EX19D007EUA001.ant.amazon.com (10.252.50.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 25 Sep 2024 15:40:58 +0000
Received: from email-imr-corp-prod-iad-1box-1a-6851662a.us-east-1.amazon.com
 (10.25.36.210) by mail-relay.amazon.com (10.250.64.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Wed, 25 Sep 2024 15:40:58 +0000
Received: from dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com (dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com [10.253.79.181])
	by email-imr-corp-prod-iad-1box-1a-6851662a.us-east-1.amazon.com (Postfix) with ESMTPS id 578CC401C3;
	Wed, 25 Sep 2024 15:40:55 +0000 (UTC)
From: Fares Mehanna <faresx@amazon.de>
To: <rppt@kernel.org>
CC: <akpm@linux-foundation.org>, <ardb@kernel.org>, <arnd@arndb.de>,
	<bhelgaas@google.com>, <broonie@kernel.org>, <catalin.marinas@arm.com>,
	<david@redhat.com>, <faresx@amazon.de>, <james.morse@arm.com>,
	<javierm@redhat.com>, <jean-philippe@linaro.org>, <joey.gouly@arm.com>,
	<kristina.martsenko@arm.com>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <mark.rutland@arm.com>, <maz@kernel.org>,
	<nh-open-source@amazon.com>, <oliver.upton@linux.dev>, <ptosi@google.com>,
	<rdunlap@infradead.org>, <rkagan@amazon.de>, <shikemeng@huaweicloud.com>,
	<suzuki.poulose@arm.com>, <tabba@google.com>, <will@kernel.org>,
	<yuzenghui@huawei.com>
Subject: Re: [RFC PATCH 0/7] support for mm-local memory allocations and use it
Date: Wed, 25 Sep 2024 15:33:47 +0000
Message-ID: <20240925153347.94589-1-faresx@amazon.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <Zu1r5-JnL3sduoqy@kernel.org>
References: <Zu1r5-JnL3sduoqy@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

Thanks for taking a look and apologies for my delayed response.

> Having a VMA in user mappings for kernel memory seems weird to say the
> least.

I see your point and agree with you. Let me explain the motivation, pros and
cons of the approach after answering your questions.

> Core MM does not expect to have VMAs for kernel memory. What will happen if
> userspace ftruncates that VMA? Or registers it with userfaultfd?

In the patch, I make sure the pages are faulted in, locked and sealed to make
sure the VMA is practically off-limits from the owner process. Only after that
I change the permissions to be used by the kernel.

> This approach seems much more reasonable and it's not that it was entirely
> arch-specific. There is some plumbing at arch level, but the allocator is
> anyway arch-independent. 

So I wanted to explore a simple solution to implement mm-local kernel secret
memory without much arch dependent code. I also wanted to reuse as much of
memfd_secret() as possible to benefit from what is done already and possible
future improvements to it.

Keeping the secret pages in user virtual addresses is easier as the page table
entries are not global by default so no special handling for spawn(). keeping
them tracked in VMA shouldn't require special handling for fork().

The challenge was to keep the virtual addresses / VMA away from user control as
long as the kernel is using it, and signal the mm core that this VMA is special
so it is not merged with other VMAs.

I believe locking the pages, sealing the VMA, prefaulting the pages should make
it practicality away of user space influence.

But the current approach have those downsides: (That I can think of)
1. Kernel secret user virtual addresses can still be used in functions accepting
   user virtual addresses like copy_from_user / copy_to_user.
2. Even if we are sure the VMA is off-limits to userspace, adding VMA with
   kernel addresses will increase attack surface between userspace and the
   kernel.
3. Since kernel secret memory is mapped in user virtual addresses, it is very
   easy to guess the exact virtual address (using binary search), and since
   this functionality is designed to keep user data, it is fair to assume the
   userspace will always be able to influence what is written there.
   So it kind of breaks KASLR for those specific pages.
4. It locks user virtual memory away, this may break some software if they
   assumed they can mmap() into specific places.

One way to address most of those concerns while keeping the solution almost arch
agnostic is is to allocate reasonable chunk of user virtual memory to be only
used for kernel secret memory, and not track them in VMAs.
This is similar to the old approach but instead of creating non-global kernel
PGD per arch it will use chunk of user virtual memory. This chunk can be defined
per arch, and this solution won't use memfd_secret().
We can then easily enlighten the kernel about this range so the kernel can test
for this range in functions like access_ok(). This approach however will make
downside #4 even worse, as it will reserve bigger chunk of user virtual memory
if this feature is enabled.

I'm also very okay switching back to the old approach with the expense of:
1. Supporting fewer architectures that can afford to give away single PGD.
2. More complicated arch specific code.

Also @graf mentioned how aarch64 uses TTBR0/TTBR1 for user and kernel page
tables, I haven't looked at this yet but it probably means that kernel page
table will be tracked per process and TTBR1 will be switched during context
switching.

What do you think? I would appreciate your opinion before working on the next
RFC patch set.

Thanks!
Fares.



Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

