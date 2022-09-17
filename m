Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4CAC54EE9
	for <kvmarm@archiver.kernel.org>; Sat, 17 Sep 2022 22:15:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BE544B7FA;
	Sat, 17 Sep 2022 18:15:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nhXJ88CZig7O; Sat, 17 Sep 2022 18:15:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB0614B64F;
	Sat, 17 Sep 2022 18:15:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 544594B64F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Sep 2022 18:15:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 18vzFY1E84xx for <kvmarm@lists.cs.columbia.edu>;
 Sat, 17 Sep 2022 18:15:53 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 18DF04B640
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Sep 2022 18:15:53 -0400 (EDT)
Date: Sat, 17 Sep 2022 22:15:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1663452952;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=bd3sEPoVSDCUAiGaLQLdpHOpOUlA4arxIg/OmjMFbsY=;
 b=KUA3uev4VXU68yP+xFPvAVZdlFTdSjbn43CFxnswecUdBlsbHWjL8Th+AFJuEAZFltTgA6
 IlCIydQMtL5NFY1cmahkrl84nM9WsxwWbhlCHaAz7WNwWBd7WFiisb6URSNJ0GuBnmj0aK
 2n3LlR4WYKBoaAvJd/TgJHA2mfheFHY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v6 02/13] KVM: selftests: aarch64: Add virt_get_pte_hva()
 library function
Message-ID: <YyZHFPCqnlk4PbcO@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
 <20220906180930.230218-3-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220906180930.230218-3-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, andrew.jones@linux.dev, maz@kernel.org,
 bgardon@google.com, pbonzini@redhat.com, axelrasmussen@google.com,
 kvmarm@lists.cs.columbia.edu, dmatlack@google.com
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

On Tue, Sep 06, 2022 at 06:09:19PM +0000, Ricardo Koller wrote:
> Add a library function to get the PTE (a host virtual address) of a
> given GVA.  This will be used in a future commit by a test to clear and
> check the access flag of a particular page.
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
