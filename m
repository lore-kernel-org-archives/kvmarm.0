Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B72C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 17:05:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B84ED4B844;
	Fri,  9 Dec 2022 12:05:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0pJw58sKQVf7; Fri,  9 Dec 2022 12:05:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 532EF4B906;
	Fri,  9 Dec 2022 12:05:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F4494B8A7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 12:05:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id is0bssknrBSe for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2022 12:05:32 -0500 (EST)
Received: from out-250.mta0.migadu.com (out-250.mta0.migadu.com
 [91.218.175.250])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD64E4B844
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 12:05:32 -0500 (EST)
Date: Fri, 9 Dec 2022 17:05:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670605531;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=7PHXtVfxL4Wco+emkfnuAlef7YnCwHHQo9a8I78AtDM=;
 b=XLTfOjcaFKd5ETBncO1R51Wln8mQ4dix7kBINL1+Hznswp0sRnYGkvxDCZj5uEpEGO5iwo
 O2aPG/8KAn7awL9px9tK0Ty+Q1XhHBeu2K4bSsTJbKy343i3ISeE4lO/vpKnbNwmp+mjLL
 vGPTlSpOfaLEzO/mtStWIp8ML4jY2oE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
Message-ID: <Y5Nq0a2JxUP+JuP+@google.com>
References: <20221205155845.233018-1-maz@kernel.org>
 <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
 <Y5EK5dDBhutOQTf6@google.com>
 <5e51cf73-5d51-835f-8748-7554a65d9111@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5e51cf73-5d51-835f-8748-7554a65d9111@redhat.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Usama Arif <usama.arif@bytedance.com>,
 Bagas Sanjaya <bagasdotme@gmail.com>, Ben Gardon <bgardon@google.com>,
 "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Marek Szyprowski <m.szyprowski@samsung.com>, Marc Zyngier <maz@kernel.org>,
 Steven Price <steven.price@arm.com>, linux-arm-kernel@lists.infradead.org,
 Jakub Kicinski <kuba@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Brown <broonie@kernel.org>,
 kvmarm@lists.linux.dev, Peter Collingbourne <pcc@google.com>,
 Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>, Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
 Andrew Morton <akpm@linux-foundation.org>
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

Hey Paolo,

On Fri, Dec 09, 2022 at 05:56:50PM +0100, Paolo Bonzini wrote:
> On 12/7/22 22:51, Oliver Upton wrote:
> > > 
> > > I haven't pushed to kvm/next yet to give you time to check, so the
> > > merge is currently in kvm/queue only.
> > Have a look at this series, which gets things building and actually
> > passing again:
> > 
> > https://lore.kernel.org/kvm/20221207214809.489070-1-oliver.upton@linux.dev/
> 
> Thank you!  Squashed 1-2 and applied 3-4.

I actually wound up sending a v2 for this :)

1-2 are the same, but I addressed some of Sean's feedback and also
pulled in more fixes. In addition to the problems with page_fault_test,
other KVM selftests were magically failing on arm64 because identity
mapping ucall MMIO punched a hole straight through the program image.

Mind dumping what I had in v1 and applying this instead?

https://lore.kernel.org/kvm/20221209015307.1781352-1-oliver.upton@linux.dev/

Thanks!

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
