Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86083463B74
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 16:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790267581; cv=none; b=k2G7YScgFX137n1zfT9rf4a7nfShL+Uhcs0g+9WDtRDxLTuLtDE5fzoNFBAQBMWyP87gmAI454hYl28Zou/a4O/SAii7G1r6BcEj7mDqByca5/marv65fhVCjak7YawVbZObKs91XXyKrWgnf4ZcWJP8ehgubtN+QuYTA95H5Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790267581; c=relaxed/simple;
	bh=6jk4WNq35FvtRPXwxvwFFQkIMdTLJNaw0ZthxIMDruE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LDpOOc7Q5IoNGMUgXYc6kteRoaQOqdyIq8tGEiJJf12H/v8LBKZmA2FcTJum+mpDQELqcSbHMQTDHO0eb0M5y+YP3pc+JwdbjUSoRZ7xriuvaxacCqfjV49vZGeESHsX4qk93yZZb6DXEdQSoABnsMXcC/10acwbE9zBqqr2xmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dnpfVQng; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dnpfVQng"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39b77130a7fso63670a91.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 09:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790267580; x=1790872380; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4FrL8f+6ILVgPFeXZ79NGmNXRfQTnNh/rpX573POM54=;
        b=dnpfVQngWo66tnhsJVe2lyFpaF67CWrkwUbWvxXOpmZRgSEsGeP0Xfnlv3miM6k7bo
         T4rPi2Bfy8NP1KDnglOdDX1WfQNkxjetAYWsldW2aUsFto7h3zdGmcZRy6ilnmrXcddA
         OHTXYQWyY1+dg+fZ++xg4l2PgOrzlFZy8bru3dYmEyYkBG2SapX56QuI6fGH5YuOuQ5M
         LkwKWtmkmHJdqqJUe1OYipwCJvAxXmsgH6wA30IwM7M4uF6zzDHprdAJdoT6t+pvMiMJ
         PUBI33bS+276XKt9G89n0cQn6vddWmeFrcIzajVi3FRm6ItznwtDeupJxUS4OcFljOyy
         BpzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790267580; x=1790872380;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4FrL8f+6ILVgPFeXZ79NGmNXRfQTnNh/rpX573POM54=;
        b=xEk2nygTy6yKoC8jsHM4hvCxJnm+Px053cRPwKyzXa2ebsk1ekgQN8sjQYkT6tEToe
         Qwtagi3au+uu+Tu2AFvIzlhPYY9j8voD+8E6/upCA4+s5GLSfsB5wdfbIcFn70h6u1VU
         L0w+gciKHM1pIl31HETSrqNf3d1AYOqkIzXQIP7njdPQHRoZEW7QHl/wKr2st4ulLwQT
         icrsmH+U+yF5O6cvFK5nFEAur14VHuY/ZXcni2+olluKNPuMb1miyF/zaKcVZpzM85VU
         XFerr3+lxNY4ybQ22p8+s0JQmFAl/OzcLdX7FQYvJAq7dmOl8WfxnizeXr9AOOy249G/
         Jo2A==
X-Forwarded-Encrypted: i=1; AKwUvBxQX2cSrrotvWar26mucYt2tvvFBh9xhX6oX0gLJMow+AlZAc5F1WJ0CGFknuGZPK2/w6H8ybI=@lists.linux.dev
X-Gm-Message-State: AFuF++neVz2NuEk1TvvxolX0S7QpWlrY4VST87SP9N+WD97/SLTm0KMX
	lPkN0I3Rdvx0QMKZW4qwtV8UBS1VheJ/Ym4pVEZ83xj8wJfTVw1KPpc7yF6wHuKzwDUhv/r7i+d
	MVboGDQ==
X-Received: from pgdu19.prod.google.com ([2002:a05:6a02:2f53:b0:cc7:5e81:4448])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2250:b0:39e:4c7f:8b1b
 with SMTP id 98e67ed59e1d1-3a098e37392mr2572091a91.32.1790267579477; Thu, 24
 Sep 2026 09:32:59 -0700 (PDT)
Date: Thu, 24 Sep 2026 09:32:58 -0700
In-Reply-To: <20260922071945.693714-2-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922071945.693714-1-fuad.tabba@linux.dev> <20260922071945.693714-2-fuad.tabba@linux.dev>
Message-ID: <arVQutV75u2gGVr4@google.com>
Subject: Re: [PATCH v2 1/2] KVM: selftests: Fix arm64 sysreg header dependencies
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Michal =?utf-8?Q?Koutn=C3=BD?=" <mkoutny@suse.com>, James Houghton <jthoughton@google.com>, Will Deacon <will@kernel.org>, 
	Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 22, 2026, Fuad Tabba wrote:
> The rule generating the arm64 sysreg header targets the generated
> directory, and its only prerequisite is tools/arch/arm64/tools/*,
> which expands to the inner Makefile. An existing directory looks up
> to date, so an incremental build never regenerates sysreg-defs.h for
> a change to the sysreg table. A selftest referencing a register added
> to the table since then fails with undeclared SYS_* identifiers. Clean
> builds are unaffected.
> 
> Always recurse into tools/arch/arm64/tools, whose Makefile already
> tracks the generator's inputs, and target the header rather than its
> directory. The recursion leaves the header untouched when nothing
> changed, so the dependents rebuild only when the header does.
> 
> Fixes: 70c7b704ca725 ("KVM: selftests: Avoid using forced target for generating arm64 headers")
> Link: https://lore.kernel.org/r/arGRhHgP_izSwW4T@kernel.org
> Assisted-by: LLM
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 96bab7002d39e..81dca3dbc16b4 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -303,10 +303,16 @@ arm64_hdr_outdir := $(tools_dir)/
>  endif
>  
>  GEN_HDRS := $(arm64_hdr_outdir)arch/arm64/include/generated/
> +GEN_SYSREG_DEFS := $(GEN_HDRS)asm/sysreg-defs.h
>  CFLAGS += -I$(GEN_HDRS)
>  
> -$(GEN_HDRS): $(wildcard $(arm64_tools_dir)/*)
> +# The inner Makefile tracks the generator's inputs and leaves the header
> +# untouched when nothing changed, so dependents rebuild only when it does.
> +$(GEN_SYSREG_DEFS): FORCE
>  	$(MAKE) -C $(arm64_tools_dir) OUTPUT=$(arm64_hdr_outdir)
> +
> +FORCE:
> +.PHONY: FORCE
>  endif

Definitely doesn't have to be now, but at some point should we split out some of
this arch-specific sub-Makefiles?  It's nice not having to hunt around to figure
out which tests are supported by which arch, but the amount of arch specific goo
we're accruing is getting unwieldy.

>  no-pie-option := $(call try-run, echo 'int main(void) { return 0; }' | \
> @@ -359,10 +365,10 @@ EXTRA_CLEAN += $(GEN_HDRS) \
>  	       $(TEST_GEN_OBJ) \
>  	       cscope.*
>  
> -$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_HDRS)
> +$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c $(GEN_SYSREG_DEFS)
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
>  
> -$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S $(GEN_HDRS)
> +$(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S $(GEN_SYSREG_DEFS)
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
>  
>  # Compile the string overrides as freestanding to prevent the compiler from
> @@ -372,10 +378,10 @@ $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
>  
>  $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
> -$(SPLIT_TEST_GEN_OBJ): $(GEN_HDRS)
> +$(SPLIT_TEST_GEN_OBJ): $(GEN_SYSREG_DEFS)
>  $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
>  $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
> -$(TEST_GEN_OBJ): $(GEN_HDRS)
> +$(TEST_GEN_OBJ): $(GEN_SYSREG_DEFS)
>  
>  cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
>  cscope:
> -- 
> 2.39.5
> 
