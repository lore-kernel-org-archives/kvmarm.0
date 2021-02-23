Return-Path: <SRS0=rfx0=HZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED531C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 16:35:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 349F864ED6
	for <kvmarm@archiver.kernel.org>; Tue, 23 Feb 2021 16:35:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 349F864ED6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B504C4B1F7;
	Tue, 23 Feb 2021 11:35:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DllediL2j+jz; Tue, 23 Feb 2021 11:35:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A30EB4B1EF;
	Tue, 23 Feb 2021 11:35:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 904924B1E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 11:35:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X-WF72iARQUc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Feb 2021 11:35:34 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 649E54B1E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Feb 2021 11:35:34 -0500 (EST)
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com
 [66.24.58.225])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6D82564E60;
 Tue, 23 Feb 2021 16:35:32 +0000 (UTC)
Date: Tue, 23 Feb 2021 11:35:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH v2 2/4] bug: Factor out a getter for a bug's file line
Message-ID: <20210223113530.3703dd19@gandalf.local.home>
In-Reply-To: <20210223155759.3495252-3-ascull@google.com>
References: <20210223155759.3495252-1-ascull@google.com>
 <20210223155759.3495252-3-ascull@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Cc: kernel-team@android.com, Peter Zijlstra <peterz@infradead.org>,
 maz@kernel.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Tue, 23 Feb 2021 15:57:57 +0000
Andrew Scull <ascull@google.com> wrote:

> There is some non-trivial config-based logic to get the file name and
> line number associated with a bug. Factor this out to a getter that can
> be resused.
> 
> Signed-off-by: Andrew Scull <ascull@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> ---
>  include/linux/bug.h |  3 +++
>  lib/bug.c           | 27 +++++++++++++++++----------
>  2 files changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/bug.h b/include/linux/bug.h
> index f639bd0122f3..e3841bee4c8d 100644
> --- a/include/linux/bug.h
> +++ b/include/linux/bug.h
> @@ -36,6 +36,9 @@ static inline int is_warning_bug(const struct bug_entry *bug)
>  	return bug->flags & BUGFLAG_WARNING;
>  }
>  
> +void bug_get_file_line(struct bug_entry *bug, const char **file,
> +		       unsigned int *line);
> +
>  struct bug_entry *find_bug(unsigned long bugaddr);
>  
>  enum bug_trap_type report_bug(unsigned long bug_addr, struct pt_regs *regs);
> diff --git a/lib/bug.c b/lib/bug.c
> index 4ab398a2de93..f936615176b8 100644
> --- a/lib/bug.c
> +++ b/lib/bug.c
> @@ -130,6 +130,22 @@ static inline struct bug_entry *module_find_bug(unsigned long bugaddr)
>  }
>  #endif
>  
> +void bug_get_file_line(struct bug_entry *bug, const char **file,
> +		       unsigned int *line)
> +{
> +	*file = NULL;
> +	*line = 0;
> +
> +#ifdef CONFIG_DEBUG_BUGVERBOSE
> +#ifndef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
> +	*file = bug->file;
> +#else
> +	*file = (const char *)bug + bug->file_disp;
> +#endif
> +	*line = bug->line;

Not that it should be part of this patch, as this patch is moving the code
and shouldn't modify it, but as a micro optimization, we could remove the
initialization from the beginning and place it here:

#else 
	*file = NULL;
	*line = 0;

But again, this patch is fine.

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve


> +#endif
> +}
> +
>  struct bug_entry *find_bug(unsigned long bugaddr)
>  {
>  	struct bug_entry *bug;
> @@ -156,17 +172,8 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
>  
>  	disable_trace_on_warning();
>  
> -	file = NULL;
> -	line = 0;
> +	bug_get_file_line(bug, &file, &line);
>  
> -#ifdef CONFIG_DEBUG_BUGVERBOSE
> -#ifndef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
> -	file = bug->file;
> -#else
> -	file = (const char *)bug + bug->file_disp;
> -#endif
> -	line = bug->line;
> -#endif
>  	warning = (bug->flags & BUGFLAG_WARNING) != 0;
>  	once = (bug->flags & BUGFLAG_ONCE) != 0;
>  	done = (bug->flags & BUGFLAG_DONE) != 0;

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
