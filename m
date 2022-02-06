Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33860C433EF
	for <kvmarm@archiver.kernel.org>; Sun,  6 Feb 2022 18:45:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DA8C405C6;
	Sun,  6 Feb 2022 13:45:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EJkXgSuvZ8p6; Sun,  6 Feb 2022 13:45:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36F554086C;
	Sun,  6 Feb 2022 13:45:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23C81405C6
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Feb 2022 13:45:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c9kWY4CHXB8F for <kvmarm@lists.cs.columbia.edu>;
 Sun,  6 Feb 2022 13:45:17 -0500 (EST)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
 [209.85.210.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B73664052C
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Feb 2022 13:45:17 -0500 (EST)
Received: by mail-pf1-f175.google.com with SMTP id e6so9789325pfc.7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 06 Feb 2022 10:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=g99EK4RBFIcLjOA2xsAgfPy/FWBWvPsPH9rm8hJWuN4=;
 b=biHHkqKY9Ho6lpFnUvZwHS3Q5oqNdHnItOI0AX5F4NU6WRtoewrftBfJOMU6myFuVw
 +M3wYhBHPiacfrFCkY7wbQ5phlQLfD6QNZM/QDckqZyMqFBKPudW+ryJ+gMTIWn8VS/A
 cRGemeQFuDF4522ZQFDF57DgekBIK9wYHAWPI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=g99EK4RBFIcLjOA2xsAgfPy/FWBWvPsPH9rm8hJWuN4=;
 b=XavHJOoM6hvjm4LFZSF9zX0k1Jb3C8L1XCqkrAiEY+HE5yp/o5MEyAbNcKY/aqPKc9
 oqI2ZlkNH6VJz4VnIkZF//GfBiRWOq78qEl2aB2EMr+vD+PDBwB7DKzWx3dA+zfCqNRy
 EaXpMZ1+1MDh5DbTfRCWc65NpxoYGhU2ZbSdQ6FI/G1WOPGBm508PuFJDV1J+t0Q56ht
 zjAJEmG1nIenOez1USg+nH/F9L3x2oeYJ11vkloCTrTn5RmHbKibg2XERISkXnl9julo
 69U6ZxiTa7U5a1QMkIbQe5j4EOv0yfgzCeR9TJ7pGLFxP2YDDJ9jof1FIro/rqf+BFz1
 fiTg==
X-Gm-Message-State: AOAM533ArOn53L37QSq91pkMiFfDKigK5y8DHwA8Q9n4ffrkc5w6lnMk
 vYTE3jzuvxVg/i7JzJsywOPQeg==
X-Google-Smtp-Source: ABdhPJwsGxmyQ5I5YdyWqLxqzGVpFwSbHqBQWHaTvyZjbtd3CV9mMg9vZBIckMMYD9dBGO8G2KeEOA==
X-Received: by 2002:a62:ce83:: with SMTP id y125mr12588532pfg.6.1644173116776; 
 Sun, 06 Feb 2022 10:45:16 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id bv22sm8729991pjb.31.2022.02.06.10.45.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 06 Feb 2022 10:45:16 -0800 (PST)
Date: Sun, 6 Feb 2022 10:45:15 -0800
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v4 09/17] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <202202061011.A255DE55B@keescook>
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-10-seanjc@google.com>
 <YfrQzoIWyv9lNljh@google.com>
 <CABCJKufg=ONNOvF8+BRXfLoTUfeiZZsdd8TnpV-GaNK_o-HuaA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABCJKufg=ONNOvF8+BRXfLoTUfeiZZsdd8TnpV-GaNK_o-HuaA@mail.gmail.com>
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

On Fri, Feb 04, 2022 at 09:35:49AM -0800, Sami Tolvanen wrote:
> On Wed, Feb 2, 2022 at 10:43 AM Sean Christopherson <seanjc@google.com> wrote:
> > > +DEFINE_STATIC_CALL_RET0(__perf_guest_state, *perf_guest_cbs->state);
> > > +DEFINE_STATIC_CALL_RET0(__perf_guest_get_ip, *perf_guest_cbs->get_ip);
> > > +DEFINE_STATIC_CALL_RET0(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);
> >
> > Using __static_call_return0() makes clang's CFI sad on arm64 due to the resulting
> > function prototype mistmatch, which IIUC, is verified by clang's __cfi_check()
> > for indirect calls, i.e. architectures without CONFIG_HAVE_STATIC_CALL.
> >
> > We could fudge around the issue by using stubs, massaging prototypes, etc..., but
> > that means doing that for every arch-agnostic user of __static_call_return0().
> >
> > Any clever ideas?  Can we do something like generate a unique function for every
> > DEFINE_STATIC_CALL_RET0 for CONFIG_HAVE_STATIC_CALL=n, e.g. using typeof() to
> > get the prototype?
> 
> I'm not sure there's a clever fix for this. On architectures without
> HAVE_STATIC_CALL, this is an indirect call to a function with a
> mismatching type, which CFI is intended to catch.
> 
> The obvious way to solve the problem would be to use a stub function
> with the correct type, which I agree, isn't going to scale. You can
> alternatively check if .func points to __static_call_return0 and not
> make the indirect call if it does. If neither of these options are
> feasible, you can disable CFI checking in the functions that have
> these static calls using the __nocfi attribute.
> 
> Kees, any thoughts?

I'm digging through the macros to sort this out, but IIUC, an example of
the problem is:

perf_guest_cbs->handle_intel_pt_intr is:

	unsigned int (*handle_intel_pt_intr)(void);

The declaration for this starts with:

DECLARE_STATIC_CALL(__perf_guest_handle_intel_pt_intr, *perf_guest_cbs->handle_intel_pt_intr);

which produces:

extern struct static_call_key STATIC_CALL_KEY(__perf_guest_handle_intel_pt_intr);
extern typeof(*perf_guest_cbs->handle_intel_pt_intr) STATIC_CALL_TRAMP(__perf_guest_handle_intel_pt_intr);

and the last line becomes:

extern unsigned int (*__SCT____perf_guest_handle_intel_pt_intr)(void);

with !HAVE_STATIC_CALL, when perf_guest_handle_intel_pt_intr() does:

	return static_call(__perf_guest_handle_intel_pt_intr)();

it is resolving static_call() into:

	((typeof(STATIC_CALL_TRAMP(name))*)(STATIC_CALL_KEY(name).func))

so the caller is expecting "unsigned int (*)(void)" but the prototype
of __static_call_return0 is "long (*)(void)":

long __static_call_return0(void);

Could we simply declare a type-matched ret0 trampoline too?

#define STATIC_CALL_TRAMP_RET0_PREFIX	__SCT__ret0__
#define STATIC_CALL_TRAMP_RET0(name)	__PASTE(STATIC_CALL_TRAMP_RET0_PREFIX, name)

#define DEFINE_STATIC_CALL_RET0(name, _func)				\
	static typeof(_func) STATIC_CALL_TRAMP_RET0(name) { return 0; }	\
        __DEFINE_STATIC_CALL(name, _func, STATIC_CALL_TRAMP_RET0(name));

static_call_update(__perf_guest_handle_intel_pt_intr,
		   (void *)&STATIC_CALL_TRAMP_RET0(__perf_guest_handle_intel_pt_intr))

-- 
Kees Cook
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
