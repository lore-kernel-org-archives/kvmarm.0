Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1F337B
	for <kvmarm@lists.linux.dev>; Wed,  8 Feb 2023 02:08:10 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id k14-20020a170902ce0e00b001992e19d3beso2017567plg.5
        for <kvmarm@lists.linux.dev>; Tue, 07 Feb 2023 18:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kdeur/wsj093xZjhkQILgu2CoCtxzNYrUTV2HfeSqDQ=;
        b=qUvwhQNTASGKsF9jBjCBXYmf8gZ+IZf9UYkjsE+SdjikI0JPapnrcKl5LAU9aGdaWI
         dXC54ZZYDFK74OWwseJ9WBYOQTFIUsGC7Ys2X/WBxmMxWjsl/P8aXvMIatBpxHZqtxaa
         9FFCxk76wyZd7r5uoVAi1hWsPxgQW7WqHMpbJXoIAIFHJa+4dbnr64SNbDFkEeE7YYCH
         aBVK6vzS0zUC8XlxKalgIdcTlodt3NN3Ofg8yVJWbRPDfvLjhW3KFu4hf0Nc2wI3PKdr
         vpr0Fs3XhWUnMb0pARLhuDhAQ4dPDQY96E5nWo0eyKQgFRmf9taPme1RtugRaEy5wQP+
         312w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kdeur/wsj093xZjhkQILgu2CoCtxzNYrUTV2HfeSqDQ=;
        b=3tY3NOSCxarB6RpTlJ4O+P0GseXB2Z4zyc0yI5aDrpAdrDjUNoeKFVMNiSmZpSZzZe
         XVGkhYwSCsH9qAm8RdsJnM5oxeJvGX8FdnFFQPIdSKVJ2tWptPKO+R5ay2HN5Z2Ua/gG
         8f5epsY426LX2RFAMeVPGhn/9X51s0VDlthadOjJG7j4p00myj+YlRHz0ftbPwCJDyjX
         fgZUdl1Pgqm7Px0R0VEOspNx45SUIU38puDj58oNfCb49cVX5mByWnOSTcwKwfeb0XF3
         lxIb3YisL7di2PyHpoVZsrFLeBPuivaHPEGObBhMzKlY1FX7wM8xHeTI+q5PLActcWux
         1Ejg==
X-Gm-Message-State: AO0yUKXa8cdg9MU44lAaBbetMKy65Cg1CiyFfISGhBIHpserL7zytO98
	diuEyC0jbae1AZsP9u8FJ7kGKkQZjsA=
X-Google-Smtp-Source: AK7set+vgyn3wY4rTBKErGgsYMgn/QHruHs+YGebobew5yCDK3AWs+clhnbFkQa2oXijZ6Lkz5NOgTDv90A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:182:b0:199:21af:cb8e with SMTP id
 z2-20020a170903018200b0019921afcb8emr1323668plg.21.1675822089820; Tue, 07 Feb
 2023 18:08:09 -0800 (PST)
Date: Wed,  8 Feb 2023 02:07:26 +0000
In-Reply-To: <20230118092133.320003-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230118092133.320003-1-gshan@redhat.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <167581358112.362323.5029488346682062350.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: selftests: Remove duplicate VM in memslot_perf_test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev, 
	Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com, 
	shuah@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	maciej.szmigiero@oracle.com, shan.gavin@gmail.com
Content-Type: text/plain; charset="utf-8"

On Wed, 18 Jan 2023 17:21:31 +0800, Gavin Shan wrote:
> PATCH[1] Removes the duplicate VM in memslot_perf_test
> PATCH[2] Assign guest page size in the sync area in prepare_vm()
> 
> Gavin Shan (2):
>   KVM: selftests: Remove duplicate VM in memslot_perf_test
>   KVM: selftests: Assign guest page size in sync area early in
>     memslot_perf_test
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/2] KVM: selftests: Remove duplicate VM in memslot_perf_test
      https://github.com/kvm-x86/linux/commit/e5b426879fc3
[2/2] KVM: selftests: Assign guest page size in sync area early in memslot_perf_test
      https://github.com/kvm-x86/linux/commit/45f679550d72

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
