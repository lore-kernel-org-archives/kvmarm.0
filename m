Return-Path: <SRS0=8eDP=FG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB24C64E7B
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 17:49:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B4AF8221FB
	for <kvmarm@archiver.kernel.org>; Wed,  2 Dec 2020 17:49:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4AF8221FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB8464B3DC;
	Wed,  2 Dec 2020 12:49:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ge0pA448RWnQ; Wed,  2 Dec 2020 12:49:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFFEE4B34C;
	Wed,  2 Dec 2020 12:49:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CC344B34C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 12:49:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ObOW5S6IYKu4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Dec 2020 12:49:21 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3663A4B2D6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Dec 2020 12:49:21 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id 64so4939951wra.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Dec 2020 09:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=uk3nyFML1nxsvGC9LCY/1s44UaqHe8BVZ1ofT7x457I=;
 b=XO2vQdH95v1HgdI8fzNXcFmkx63nZT1kR7WW07T3iN8xawOcOSjMcaratXT62R6aol
 18Exdx6tN6JQlynTpVUZwWTx5yEfKHqoUXJ8bp5ZP8r4TxRk36V18+/ACCyAmoetPExg
 ZhwuJ1VUm9FX8Tk3peri9lU3HFX5NozCPQXe8tUQi8I5wnwrKylWAmwqb7jEiKk0/PUt
 RA+9v3xK6ufqjU325zvSInvuQG7b6fKJz3s3f5OJPhxqbuBGwDkBUf1LXppH3UkSGxER
 OwcLDErcATCjMiaz7wGjjIGEuop04VGU2IBbBUBqQqdpTuKtFfCYhPUic/OCPb82mYON
 iQvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uk3nyFML1nxsvGC9LCY/1s44UaqHe8BVZ1ofT7x457I=;
 b=swi8Uo9MVLA1E36hL8QzTypOa01X0Azv8RSPI23SCkU+41GgIuLu36/+UnIMaC2mR6
 lLiDNeMHeH4FxtTx5BzU4y3HSc2O4cSz8bu3Oe1NZ9d/zvBRe6d9n68MVB41n0KMvtBf
 zcWoecA/fsih8uA/LJLqg9nhzjQCFTJXUKhFhZij+hBVSWiHRabMCl+NT08E5r47pkc6
 SQztLl61LweKoR1QBZ8X7KmXu1YLoPSNqMqcDLXIBgbDD7cgsogTAkgTeqTL5PvQ7dzV
 +LRZdJ63fLuvcGYqaJjpuoOXjR19x3s02Df5M4Fjm7Zkit/DBcFzBvSF/CPFus+CI7T+
 Oolw==
X-Gm-Message-State: AOAM533QoqDQzwxdGGUBz6OMbz7p9yFnDFbB7ljNJi39p7x1E+iV4adA
 C/M13XomrCk9q21PvelHP7w/5w==
X-Google-Smtp-Source: ABdhPJwzHIaRNBQgiYJ4lBdup+j980orHCD3KEsoa4QfsBkkHpXFXQVpATyCsJ/euy7BQTFO2qp3nA==
X-Received: by 2002:a5d:5482:: with SMTP id h2mr4962893wrv.18.1606931359793;
 Wed, 02 Dec 2020 09:49:19 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:5ddd:b7c5:e3c9:e87a])
 by smtp.gmail.com with ESMTPSA id u23sm2973631wmc.32.2020.12.02.09.49.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 02 Dec 2020 09:49:19 -0800 (PST)
Date: Wed, 2 Dec 2020 17:49:17 +0000
From: David Brazdil <dbrazdil@google.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH v3 16/23] kvm: arm64: Forward safe PSCI SMCs coming from
 host
Message-ID: <20201202174917.qey4ju2vrzipy4cn@google.com>
References: <20201126155421.14901-1-dbrazdil@google.com>
 <20201126155421.14901-17-dbrazdil@google.com>
 <20201127101433.GA1061@e121166-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201127101433.GA1061@e121166-lin.cambridge.arm.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>, kernel-team@android.com,
 Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On Fri, Nov 27, 2020 at 10:14:33AM +0000, Lorenzo Pieralisi wrote:
> On Thu, Nov 26, 2020 at 03:54:14PM +0000, David Brazdil wrote:
> > Forward the following PSCI SMCs issued by host to EL3 as they do not
> > require the hypervisor's intervention. This assumes that EL3 correctly
> > implements the PSCI specification.
> > 
> > Only function IDs implemented in Linux are included.
> > 
> > Where both 32-bit and 64-bit variants exist, it is assumed that the host
> > will always use the 64-bit variant.
> > 
> >  * SMCs that only return information about the system
> >    * PSCI_VERSION        - PSCI version implemented by EL3
> >    * PSCI_FEATURES       - optional features supported by EL3
> >    * AFFINITY_INFO       - power state of core/cluster
> >    * MIGRATE_INFO_TYPE   - whether Trusted OS can be migrated
> >    * MIGRATE_INFO_UP_CPU - resident core of Trusted OS
> >  * operations which do not affect the hypervisor
> >    * MIGRATE             - migrate Trusted OS to a different core
> >    * SET_SUSPEND_MODE    - toggle OS-initiated mode
> >  * system shutdown/reset
> >    * SYSTEM_OFF
> >    * SYSTEM_RESET
> >    * SYSTEM_RESET2
> 
> What about SYSTEM_SUSPEND ?
Oops, forgot that one. Will add a handler similar to CPU_SUSPEND.

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
