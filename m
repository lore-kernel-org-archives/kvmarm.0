Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65EE2FCC17
	for <kvmarm@lists.linux.dev>; Fri, 21 Nov 2025 18:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763751406; cv=none; b=oXlIMuXgrcb/pX8Em1hvVwFBaUaKJmmjRlC0ruHpohxI0WN2CY2mQq8T/7QZDqKLluuNf+lAoghgBRzFtnIYLaGc4UicSabEe7rwjBVHrRGs/ifyxxRuZrII1vY0yYHPQ66Ls8xd8S6YtsFPAA4RScScs3HdSVnI+Ve9r8hqycg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763751406; c=relaxed/simple;
	bh=NuBF5ENbl+bXo2WYVgT9d/UQPTBU/zQ6Z2Vv6/QMa20=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=cLgvPDO5n8DG7yyYSeiDizrZxGr5nq4gHAD7P4tDLCul+ICnMbsv71exRg99jHuVkpZB4ks97dnEDDS78CVwJd6hOthytihfGNvYfoaWMINqCfFaRT92yKwhniyQHSFmgg1JSPLJVjHg9DbbCFU4YaPsSlS7AGyidA3Ikw+cE0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KZldmEmE; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KZldmEmE"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297f48e81b8so35509565ad.0
        for <kvmarm@lists.linux.dev>; Fri, 21 Nov 2025 10:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763751403; x=1764356203; darn=lists.linux.dev;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gf/8Pk7Wi+5ZKHSgJ1cayHET+i6n5m5sIz+x1glR7jY=;
        b=KZldmEmEwGk87JA3WF9Tn6C4eTMmg1sBYtTgedP/HjKaUN9FlseZegzpLgwvsJKnkY
         nm6NniDbJ4MDFI6N5PsvQfe19dvcyQ0OdJ9+N+MAYwiRhezUQYTkT61fFGTB/Cf5ucby
         DrYIBJYHKCheehPPsHSLjXSHrYV5Mr54o86Rs/n9OsTIZ3IvGx4UVlL5PSZwWTXxNn/t
         Y25BPecP4FhB/4FCqwzN482GgzHLKq8W9WKdNm3qiR/IghY/FLvrp3FRM2nen80tX//y
         czTpW5lcFTCu8ViQsVU36IlbaAVuosIK5oNKFr5Rvc6jCCfJAi6+4455JvcJ50OSnPRA
         PpOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763751403; x=1764356203;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gf/8Pk7Wi+5ZKHSgJ1cayHET+i6n5m5sIz+x1glR7jY=;
        b=DNLI0SpCvvSV8ithl8cpZGSfywisbE3RWMynC0rm+AUIXxyQhyb6Hx4DC7hY75ki4v
         g/0Wno96lRW9dvCwUr8tHE8DSGxlNbbWaIUSMZR0/heyDo28EHpoyPcwK3jAyY0oIdmz
         YFeAlUXFmqhNh4a2AbVlyqUqZS2ljO1L+MhU7XtRqAeQGeKWXNAFw85ddUD8gO1UQZYT
         F43l+Ugg+JS05KOcwzL4TeN6LMnOprBGOsSwZDsgZknMBrJaUU5nhC/dVoZM81F8tQX+
         6Xx9Q30CXQvbTYr45XPNE8rrRH+Bdb52iGyQWxO2B8v4u++O/JnpfYz/xiRO+7whyApk
         ucvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWt8LOkWi7uBqgbgL3ColhgEdX/dxn8Td98CCACeaiQxYtBbejkUMnjugsE2DY0otuVVi5VSmc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqFSvdDmvIQwy7skE2VSxSviQubbTNqwD5FESmwIdUpz2jIekj
	lkz69vWKVba0D8CfD3JZWuP22OzU0xH6NSO7d6UVE+ZLMqSlB5K85L4EAvTnRspkiH1f+6nvduz
	RG6hwKQ==
X-Google-Smtp-Source: AGHT+IGl6lVP4k6Ffz1FVATVkFbVRdK/+fQjLr4mrrmG1VOjxZCvjJw3L3ZKENAl8ILCy7qu+uQ9S2crdpg=
X-Received: from plhv10.prod.google.com ([2002:a17:903:238a:b0:298:3543:5212])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:11cd:b0:298:639b:a64f
 with SMTP id d9443c01a7336-29b6beee840mr49422585ad.6.1763751403034; Fri, 21
 Nov 2025 10:56:43 -0800 (PST)
Date: Fri, 21 Nov 2025 10:55:37 -0800
In-Reply-To: <20251028225827.2269128-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251028225827.2269128-1-jmattson@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <176375118181.288827.8430542805047208308.b4-ty@google.com>
Subject: Re: [PATCH v2 0/4] KVM: selftests: Test SET_NESTED_STATE with 48-bit
 L2 on 57-bit L1
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Bibo Mao <maobibo@loongson.cn>, 
	"Pratik R. Sampat" <prsampat@amd.com>, James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 28 Oct 2025 15:30:38 -0700, Jim Mattson wrote:
> Prior to commit 9245fd6b8531 ("KVM: x86: model canonical checks more
> precisely"), KVM_SET_NESTED_STATE would fail if the state was captured
> with L2 active, L1 had CR4.LA57 set, L2 did not, and the
> VMCS12.HOST_GSBASE (or other host-state field checked for canonicality)
> had an address greater than 48 bits wide.
> 
> Add a regression test that reproduces the KVM_SET_NESTED_STATE failure
> conditions. To do so, the first three patches add support for 5-level
> paging in the selftest L1 VM.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/4] KVM: selftests: Use a loop to create guest page tables
      https://github.com/kvm-x86/linux/commit/ae5b498b8da9
[2/4] KVM: selftests: Use a loop to walk guest page tables
      https://github.com/kvm-x86/linux/commit/2103a8baf5cb
[3/4] KVM: selftests: Change VM_MODE_PXXV48_4K to VM_MODE_PXXVYY_4K
      https://github.com/kvm-x86/linux/commit/ec5806639e39
[4/4] KVM: selftests: Add a VMX test for LA57 nested state
      https://github.com/kvm-x86/linux/commit/6a8818de21d2

--
https://github.com/kvm-x86/linux/tree/next
