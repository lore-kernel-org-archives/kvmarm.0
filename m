Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB897174DA
	for <kvmarm@lists.linux.dev>; Fri, 18 Aug 2023 23:03:43 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d72e09f1263so1751741276.1
        for <kvmarm@lists.linux.dev>; Fri, 18 Aug 2023 16:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692399822; x=1693004622;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=28NglzIO6cp/vzLfU4W3yc26zb3SzMF2NIoeJVJxjcQ=;
        b=EVGfgwe5loZZR0WMUgpJEOZteslGNWIqlIRhDe/gbts+F4/yw7LopoWIr9pAXN/gct
         vmDVXSSz1qYQsgmOG56EVjufIZ8uHJIc0K2fjYh54YGOjsi7Y2c13ZQR7k+mneDCdJ6K
         fzW5DxeEtavJtj3e3uV6c2SWgwD/YmEbj2Rv9dwQ6wRuQzmdnahyzKBwtcnM92PUpCV2
         6SViYhyQd8PzIgA5SnclKlRnW0JgjAUS06yCK7QyV0vkFW6Zt0VuYiJbLr9XMzWwR30M
         Wq85gyIx9s0/FGvGJHcq/Jks4zP9GUvni76QMTBxGvpnvPGwvzqq5FqhBNo14dUbWrMQ
         g0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692399822; x=1693004622;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=28NglzIO6cp/vzLfU4W3yc26zb3SzMF2NIoeJVJxjcQ=;
        b=VHaHsdJJTYDQRXkuR2JrwsPHbALjGtCOjPbzZgC3EEyomY9hDDPdETEk4NtRLBzSlL
         tBT67UGWFedfWdn4JTGt6ctPWc0zpSZKPf+SXCM6eWTkGMbzDrCVLl5liyo6uAek1IaU
         CvsrHDPwX4feFlGciNj66xg7CSmJjEDV7vkZQglW1Rlt6HPLLHgXyjrDc9wudEgsxjgh
         I4h85Yw4aWwSTrj2pzThIc/GkZjsiqLD4Bvfp2RUhPld4SLikuMaJolv27N9fGJIDAF5
         H9AhLAQHGwOuI8uEQ4H7cUE4uhNVPZ+k03aeM2Szglr0HiwK2xwWXgvgHsK0I9QLDJJh
         0WjQ==
X-Gm-Message-State: AOJu0Yy/qZ5ETnK7hsiEceHXlvFxhSMKp6oJfUwdqMQDATsEo3fNCI7u
	oyMzn8THjexEENp+zbYnxqsEA+RmXrk=
X-Google-Smtp-Source: AGHT+IEiW/RghuqZOFRro09VfZa9EIt3/32aXeBy5eI/raBp2zbRsudvcD77PZeJQ//x65k1pSmrq3qMqqs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d149:0:b0:d4c:2a34:aeab with SMTP id
 i70-20020a25d149000000b00d4c2a34aeabmr6800ybg.11.1692399822583; Fri, 18 Aug
 2023 16:03:42 -0700 (PDT)
Date: Fri, 18 Aug 2023 16:03:41 -0700
In-Reply-To: <diqzo7ji30eo.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-29-seanjc@google.com> <diqzo7ji30eo.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <ZN/4zZFrsPdh/mLo@google.com>
Subject: Re: [RFC PATCH v11 28/29] KVM: selftests: Add basic selftest for guest_memfd()
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	willy@infradead.org, akpm@linux-foundation.org, paul@paul-moore.com, 
	jmorris@namei.org, serge@hallyn.com, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	chao.p.peng@linux.intel.com, tabba@google.com, jarkko@kernel.org, 
	yu.c.zhang@linux.intel.com, vannapurve@google.com, mail@maciej.szmigiero.name, 
	vbabka@suse.cz, david@redhat.com, qperret@google.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 07, 2023, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > +	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE, total_size + page_size, page_size);
> > +	TEST_ASSERT(ret, "fallocate beginning at total_size should fail");
> 
> This should be
> 
> TEST_ASSERT(ret, "fallocate beginning after total_size should fail");

Roger that, I'll push a fixup commit directly to kvm-x86/guest_memfd.  Thanks!
