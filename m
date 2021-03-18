Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97821C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 15:23:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F20AF64F2B
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 15:23:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F20AF64F2B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D3C64B5DB;
	Thu, 18 Mar 2021 11:23:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y8a1b2Bflzg0; Thu, 18 Mar 2021 11:23:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8211C4B73C;
	Thu, 18 Mar 2021 11:23:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77AC54B72B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 11:23:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hgZjXFmlslVG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 11:23:01 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8444F4B5DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 11:23:01 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF1B564ED2;
 Thu, 18 Mar 2021 15:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616080980;
 bh=mEQoYYW03+n7rE41uzq69ZplXBkkU8KS/BNxxVOwn7I=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Xn0uBaAJEE5oE2alSCe/7vHz+O9OGWi3Pnd/ZidnazF3J8/O3flIA5/6iDDoFyZWK
 kquFaOJ9K7d93hnReLcZFSgNsanVGaZR+psZcjFpyao0FIRk29sbDzyz1eg8nozy1W
 RGF0l4mFfMjPrVd1kKr0cFhbHyNs8/9odcwKEcfSCJTy1SGpi684DE64BFJl7M9Qit
 bvmH8l57HCPr9zcmfjAzEgJzDPNjkomNeMnqaFahfZe6Ohyv8GWnX3+Fzw4LOnUwIE
 ZsCAMkvWCs4IKBrJOlGph2YBSZzBz9tj5datNJwY/JeL4/ZKBQmSxysc5aRYRNATBa
 N2CnfCYOXymNQ==
Date: Thu, 18 Mar 2021 15:22:55 +0000
From: Will Deacon <will@kernel.org>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH v3 3/5] bug: Assign values once in bug_get_file_line()
Message-ID: <20210318152254.GC7531@willie-the-truck>
References: <20210318143311.839894-1-ascull@google.com>
 <20210318143311.839894-4-ascull@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210318143311.839894-4-ascull@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Peter Zijlstra <peterz@infradead.org>, catalin.marinas@arm.com,
 "Steven Rostedt \(VMware\)" <rostedt@goodmis.org>, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Mar 18, 2021 at 02:33:09PM +0000, Andrew Scull wrote:
> Set bug_get_file_line()'s output parameter values directly rather than
> first nullifying them and then conditionally setting new values.
> 
> Signed-off-by: Andrew Scull <ascull@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> ---
>  lib/bug.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/bug.c b/lib/bug.c
> index e65398082cbc..45a0584f6541 100644
> --- a/lib/bug.c
> +++ b/lib/bug.c
> @@ -130,9 +130,6 @@ static inline struct bug_entry *module_find_bug(unsigned long bugaddr)
>  void bug_get_file_line(struct bug_entry *bug, const char **file,
>  		       unsigned int *line)
>  {
> -	*file = NULL;
> -	*line = 0;
> -
>  #ifdef CONFIG_DEBUG_BUGVERBOSE
>  #ifndef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
>  	*file = bug->file;
> @@ -140,6 +137,9 @@ void bug_get_file_line(struct bug_entry *bug, const char **file,
>  	*file = (const char *)bug + bug->file_disp;
>  #endif
>  	*line = bug->line;
> +#else
> +	*file = NULL;
> +	*line = 0;

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
