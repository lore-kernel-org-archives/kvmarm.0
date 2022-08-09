Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2765DC19F2D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 21:38:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 982A74CEEA;
	Tue,  9 Aug 2022 17:38:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id po1h3fZnO674; Tue,  9 Aug 2022 17:38:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F2DE4CF16;
	Tue,  9 Aug 2022 17:38:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BE4D4CEEA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 17:38:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iTR5mLvhl9Em for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 17:38:35 -0400 (EDT)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 603B44CF12
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 17:38:35 -0400 (EDT)
Received: by mail-pj1-f41.google.com with SMTP id
 p14-20020a17090a74ce00b001f4d04492faso205641pjl.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Aug 2022 14:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc;
 bh=o8zzCiEtSfxFlAxZzKI7HqSYHHhfKIfxoT6ysA2mwRQ=;
 b=mz0Fjqu9dzg7nU0PCSUBlYeJVZ9gb/NvoAjp4klMVPqMWGBhoN7T4Z0A+Z5dI9GQUf
 nxY8R3gRW2W8Mae+vrr6Ov/btiZ6+vE6BrY4Kb0G+XnUcpHcplU/LqFC9QnvoIdHE0Bu
 /g+230V6KN4RaDF9l6q2AfbJ23OtFDrDFA/ZMoH1TKvz1vpKNLrWVhnVtBHLzuUnvgWh
 pTqM3Ksr4fhJ+B6dQYaaJwgY5DL1KZxkL90D8RAM62drfSjOX14jlDF7PTkcKwENBXt2
 MtUmXKj5VBSQVKk2fMfgtzxlsBv5KLSPjbe0t1StTlu3+6htVnbMD0KVSeQgELY8ybIb
 afPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
 bh=o8zzCiEtSfxFlAxZzKI7HqSYHHhfKIfxoT6ysA2mwRQ=;
 b=WKs6Zqw7bd3kItJuxBlnWsEEGjKT5mtngENwf10SPy9F0bPhagnyHIJOQ0FidMzK8G
 tpZSPLmh/KEkjNblDc7xtT09WVZ67vExsrFrlntf7AlZLyKl3DU1yJf1UmsgVZREx5jg
 WsgnN1m8G5dy2jg1mpiKyU1+bz/b3vD//GytWI+zOIF1bFMpeUyE3MPlZY5ca/vd1fvv
 O2zgIqHpRYW92B3jGZMIgreryv9hj1jXSOcDYsovlMHTXdbsBWmCWM0F4tI7jYu0AZFE
 Yuxzwhy1n1fVwwGMgZaC+Qx44d5Y+JEixoNCRS421BGar/UldJQxBTrvqG+okgO6Rhcz
 c89Q==
X-Gm-Message-State: ACgBeo0wz317Y6r9rwDkS/zP3EeAvomeTojTtUFY3Gd49bcJAMhT7Nob
 XcUnlPx3P5SMQ+MEllymeyJl8Q==
X-Google-Smtp-Source: AA6agR4J/HhURqfPvPpi43Q7Bija6xPtnqX55byjC51oilG8jZwpXiNOXRPE6CWpwE3OWAgXLExSyw==
X-Received: by 2002:a17:902:8b87:b0:16f:1bb7:984a with SMTP id
 ay7-20020a1709028b8700b0016f1bb7984amr24756042plb.113.1660081114308; 
 Tue, 09 Aug 2022 14:38:34 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 u8-20020a1709026e0800b0016f1204cde8sm11219119plk.301.2022.08.09.14.38.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 09 Aug 2022 14:38:33 -0700 (PDT)
Date: Tue, 9 Aug 2022 21:38:29 +0000
From: Sean Christopherson <seanjc@google.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/2] KVM: selftests: Make rseq compatible with glibc-2.35
Message-ID: <YvLT1fd8ddybF5Uw@google.com>
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-2-gshan@redhat.com>
 <8735e6ncxw.fsf@oldenburg.str.redhat.com>
 <7844e3fa-e49e-de75-e424-e82d3a023dd6@redhat.com>
 <87o7wtnay6.fsf@oldenburg.str.redhat.com>
 <616d4de6-81f6-9d14-4e57-4a79fec45690@redhat.com>
 <797306043.114963.1660047714774.JavaMail.zimbra@efficios.com>
 <1014177394.115022.1660052656961.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1014177394.115022.1660052656961.JavaMail.zimbra@efficios.com>
Cc: Florian Weimer <fweimer@redhat.com>, shan gavin <shan.gavin@gmail.com>,
 KVM list <kvm@vger.kernel.org>, maz <maz@kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 andrew jones <andrew.jones@linux.dev>, yihyu@redhat.com,
 linux-kselftest <linux-kselftest@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, shuah <shuah@kernel.org>,
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

On Tue, Aug 09, 2022, Mathieu Desnoyers wrote:
> ----- On Aug 9, 2022, at 8:21 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:
> 
> > ----- Gavin Shan <gshan@redhat.com> wrote:
> >> Hi Florian,
> >> 
> >> On 8/9/22 5:16 PM, Florian Weimer wrote:
> >> >>> __builtin_thread_pointer doesn't work on all architectures/GCC
> >> >>> versions.
> >> >>> Is this a problem for selftests?
> >> >>>
> >> >>
> >> >> It's a problem as the test case is running on all architectures. I think I
> >> >> need introduce our own __builtin_thread_pointer() for where it's not
> >> >> supported: (1) PowerPC  (2) x86 without GCC 11
> >> >>
> >> >> Please let me know if I still have missed cases where
> >> >> __buitin_thread_pointer() isn't supported?
> >> > 
> >> > As far as I know, these are the two outliers that also have rseq
> >> > support.  The list is a bit longer if we also consider non-rseq
> >> > architectures (csky, hppa, ia64, m68k, microblaze, sparc, don't know
> >> > about the Linux architectures without glibc support).
> >> > 
> >> 
> >> For kvm/selftests, there are 3 architectures involved actually. So we
> >> just need consider 4 cases: aarch64, x86, s390 and other. For other
> >> case, we just use __builtin_thread_pointer() to maintain code's
> >> integrity, but it's not called at all.
> >> 
> >> I think kvm/selftest is always relying on glibc if I'm correct.
> > 
> > All those are handled in the rseq selftests and in librseq. Why duplicate all
> > that logic again?
> 
> More to the point, considering that we have all the relevant rseq registration
> code in tools/testing/selftests/rseq/rseq.c already, and the relevant thread
> pointer getter code in tools/testing/selftests/rseq/rseq-*thread-pointer.h,
> is there an easy way to get test applications in tools/testing/selftests/kvm
> and in tools/testing/selftests/rseq to share that common code ?
> 
> Keeping duplicated compatibility code is bad for long-term maintainability.

Any reason not to simply add tools/lib/rseq.c and then expose a helper to get the
registered rseq struct?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
