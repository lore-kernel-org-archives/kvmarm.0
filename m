Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D157C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  7 Feb 2022 14:34:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FE3B49E5F;
	Mon,  7 Feb 2022 09:34:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2pFF+L-d8tBH; Mon,  7 Feb 2022 09:34:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6708B49EB4;
	Mon,  7 Feb 2022 09:34:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF9B541014
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Feb 2022 12:36:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WMWdqZDHeaZY for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Feb 2022 12:36:00 -0500 (EST)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com
 [209.85.219.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A6ABE40B6C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Feb 2022 12:36:00 -0500 (EST)
Received: by mail-yb1-f176.google.com with SMTP id c6so20886019ybk.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Feb 2022 09:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=GyLfy4Dxm37OlH/M49r+dDaiFcR/y+/lQ3SW4Qp9TQg=;
 b=jOwooElC3fQwQWVC3MwtgG1xiGKscZ3GouURpYpw9onOil65CqRD+3AcEPPJEibimA
 u8AEVUs5rz5Wz6BHwti9PQXpcfLI99IyGB6W6iwskCt6ZonRllyvZMdBOF2l0xMFJKDB
 6DSpLCYGSBI45i/y4eRzSgv4LLw7GEkocNoWI9+OVAKZSjqH/1CloMYCyYL4chL3trz1
 fMSS9d3oAHMUy5GyN4u2BvbDtnZTcGdUwHj97p9ljekfc29gShtw2SPPRfolTAGQXZdg
 z7jm0rMn4mKXjtsmxvlFMwxOmSDtqGC0LffclclC9WMAk0HsuNMHRkxlmn/O7/X5JzQy
 Cnsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=GyLfy4Dxm37OlH/M49r+dDaiFcR/y+/lQ3SW4Qp9TQg=;
 b=MViOUwi1CrLokaUwXV1Y7j7yMssNHMc8tRGxY7w/kveBcSwNebMLVhSu8xnI43nl90
 n2rB3UpzXCM2gB8sKyZPHGlDWKS6+ZvXQTjAywgFFdqBewOL0U/vzq2/g9WYTRE1CMO+
 ZIodczNhBf0sOBwCvcLFYAyxboMubShoPmscS0YHvrcXOMhM3GegI/Xm9AMXZFyI3UrP
 u/yjLvVDvQ5qY/85OcRUVksGZIXt+5lC+CFiYdVhbRrir3oEik5CHHINIzBh6jAx7EL0
 XNOAwfMNQ79A08BvYFgfl/Wu9CpNuFA+LrfXvJxUYzjRLQH+QBG/kwhKeLr6bOnh6OhK
 6vFA==
X-Gm-Message-State: AOAM531O4DhD9s9/EH2/sWKgNLTqNuH1bx4zQK5XLrpca7mh671qoMv6
 y1Nfvp4Jfu+Bw6pDKujdDrzZY47T9CxJUJYE7pY9Xg==
X-Google-Smtp-Source: ABdhPJyOuH/xsfHATqvWwkAHVOssf+KzvqDIGJLV+nRclvMzKT1C9hxOlnyCwYh8reroGVnT571LCyViKkMZtG6Mb0U=
X-Received: by 2002:a81:9f08:: with SMTP id s8mr3434556ywn.291.1643996159883; 
 Fri, 04 Feb 2022 09:35:59 -0800 (PST)
MIME-Version: 1.0
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-10-seanjc@google.com>
 <YfrQzoIWyv9lNljh@google.com>
In-Reply-To: <YfrQzoIWyv9lNljh@google.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 4 Feb 2022 09:35:49 -0800
Message-ID: <CABCJKufg=ONNOvF8+BRXfLoTUfeiZZsdd8TnpV-GaNK_o-HuaA@mail.gmail.com>
Subject: Re: [PATCH v4 09/17] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
To: Sean Christopherson <seanjc@google.com>, Kees Cook <keescook@chromium.org>
X-Mailman-Approved-At: Mon, 07 Feb 2022 09:34:10 -0500
Cc: Will McVicker <willmcvicker@google.com>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

On Wed, Feb 2, 2022 at 10:43 AM Sean Christopherson <seanjc@google.com> wrote:
> > +DEFINE_STATIC_CALL_RET0(__perf_guest_state, *perf_guest_cbs->state);
> > +DEFINE_STATIC_CALL_RET0(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
> > +DEFINE_STATIC_CALL_RET0(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);
>
> Using __static_call_return0() makes clang's CFI sad on arm64 due to the resulting
> function prototype mistmatch, which IIUC, is verified by clang's __cfi_check()
> for indirect calls, i.e. architectures without CONFIG_HAVE_STATIC_CALL.
>
> We could fudge around the issue by using stubs, massaging prototypes, etc..., but
> that means doing that for every arch-agnostic user of __static_call_return0().
>
> Any clever ideas?  Can we do something like generate a unique function for every
> DEFINE_STATIC_CALL_RET0 for CONFIG_HAVE_STATIC_CALL=n, e.g. using typeof() to
> get the prototype?

I'm not sure there's a clever fix for this. On architectures without
HAVE_STATIC_CALL, this is an indirect call to a function with a
mismatching type, which CFI is intended to catch.

The obvious way to solve the problem would be to use a stub function
with the correct type, which I agree, isn't going to scale. You can
alternatively check if .func points to __static_call_return0 and not
make the indirect call if it does. If neither of these options are
feasible, you can disable CFI checking in the functions that have
these static calls using the __nocfi attribute.

Kees, any thoughts?

Sami
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
