Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068AEC4708E
	for <kvmarm@archiver.kernel.org>; Tue, 13 Dec 2022 00:17:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BBC34B964;
	Mon, 12 Dec 2022 19:17:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K9exeOFNIecF; Mon, 12 Dec 2022 19:17:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61EDF4B95A;
	Mon, 12 Dec 2022 19:17:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 506CA4B93E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9aa0eFi0zKWc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 19:17:09 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F41A34B920
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 19:17:08 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 195-20020a2505cc000000b0071163981d18so14854687ybf.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 16:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=content-transfer-encoding:cc:to:from:subject:message-id:references
 :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
 :message-id:reply-to;
 bh=Dh9OV8WXLZqVkS0eTF+TxxkJJsKrkd0m2OX0yvUCB3o=;
 b=sw5AF+UJzrAam2lKYUO+DY3lJy12wG52jO14k7mzCjLcxxLIwp1wBpj6wVqYtqBXVF
 59vS4E7gW4naKYM6Hk7aGKYpNTStZA8AyeHKiS1Zp63lxywrCOInD4USN6MkBgBw4NoX
 eN2lxEjW9PEtkdVREzFNueicrHCc0exuvCAPIMk3YVVS7eklH+VcuXQPTh0ZS9Sd5LX8
 cGWE/0zqnV0g/j784hDl74HTeHWiysY9ZLAx8E3jTWdl+pYwXeHcFR4+9h/Mt74o1u5K
 B3cgL2TWXr+P5NwxWcePS55Ar3q2GV+q43pv8aj7jsOs55kDdd5RUw2jebRRAKHKGp8g
 1SMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:cc:to:from:subject:message-id:references
 :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
 :cc:subject:date:message-id:reply-to;
 bh=Dh9OV8WXLZqVkS0eTF+TxxkJJsKrkd0m2OX0yvUCB3o=;
 b=GPWnQXv1oyELVAAMlpBNUyvmvoHXOAAkYVdHAmd7/kJjG64Oi2P0YIs/OnfNG/x3K3
 OKddySMFqbcMmdRHydFsB3Ohs92+qzZoqvvrpEet6T9eRIMgG0O6EDQeq39q8gRP+Mrd
 BuXtB4OWWevA3J+P+9MOscRib92EhjZ1WndJAaXnhNu/Yy3WlmXnWN9/zcLlagEduub8
 jTlty+20STDoMt2UTqxwPFlANGmZ8dYTlltISNLRTGUtYbqVteWcwloyeybFiNBY8gWA
 PkwCO/iEcIpLhQqW6N8hH+0jPvD/yoAW6g6ZV71vtMYtVVdvBu0RH1oucA+t8fZXYv2C
 Oweg==
X-Gm-Message-State: ANoB5pmfWicl+8G9nFVWMGvT15NrGxxDQH09iWF2RHu0TpQdbtdoRNy3
 056co5/pDhee+wzDjG/7ZtQCDqjeBq0=
X-Google-Smtp-Source: AA0mqf6PAlQug9BZraIHZdHpqKIVbXCcKOa0uk6qj29geZVqkrX39aClmamGhM5+3qzba2DS0aZNeAJ6gmU=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ca0f:0:b0:38f:fa8e:99da with SMTP id
 m15-20020a0dca0f000000b0038ffa8e99damr12937224ywd.355.1670890628580; Mon, 12
 Dec 2022 16:17:08 -0800 (PST)
Date: Tue, 13 Dec 2022 00:16:46 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-8-seanjc@google.com>
Subject: [PATCH 07/14] KVM: selftests: Use proper function prototypes in
 probing code
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
 Tom Rix <trix@redhat.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

TWFrZSB0aGUgbWFpbigpIGZ1bmN0aW9ucyBpbiB0aGUgcHJvYmluZyBjb2RlIHByb3BlciBwcm90
b3R5cGVzIHNvIHRoYXQKY29tcGlsaW5nIHRoZSBwcm9iaW5nIGNvZGUgd2l0aCBtb3JlIHN0cmlj
dCBmbGFncyB3b24ndCBnZW5lcmF0ZSBmYWxzZQpuZWdhdGl2ZXMuCgogIDxzdGRpbj46MTo1OiBl
cnJvcjogZnVuY3Rpb24gZGVjbGFyYXRpb24gaXNu4oCZdCBhIHByb3RvdHlwZSBbLVdlcnJvcj1z
dHJpY3QtcHJvdG90eXBlc10KClNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNl
YW5qY0Bnb29nbGUuY29tPgotLS0KIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9NYWtlZmls
ZSB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vTWFrZWZpbGUgYi90
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vTWFrZWZpbGUKaW5kZXggZDc2MWE3N2MzYTgwLi5j
MjJjMzAwMjQ5MmQgMTAwNjQ0Ci0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9NYWtl
ZmlsZQorKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vTWFrZWZpbGUKQEAgLTE5Niwx
MSArMTk2LDExIEBAIENGTEFHUyArPSAtV2FsbCAtV3N0cmljdC1wcm90b3R5cGVzIC1XdW5pbml0
aWFsaXplZCAtTzIgLWcgLXN0ZD1nbnU5OSBcCiAJLUkkKDxEKSAtSWluY2x1ZGUvJChBUkNIX0RJ
UikgLUkgLi4vcnNlcSAtSS4uICQoRVhUUkFfQ0ZMQUdTKSBcCiAJJChLSERSX0lOQ0xVREVTKQog
Ci1uby1waWUtb3B0aW9uIDo9ICQoY2FsbCB0cnktcnVuLCBlY2hvICdpbnQgbWFpbigpIHsgcmV0
dXJuIDA7IH0nIHwgXAorbm8tcGllLW9wdGlvbiA6PSAkKGNhbGwgdHJ5LXJ1biwgZWNobyAnaW50
IG1haW4odm9pZCkgeyByZXR1cm4gMDsgfScgfCBcCiAgICAgICAgICQoQ0MpIC1XZXJyb3IgLW5v
LXBpZSAteCBjIC0gLW8gIiQkVE1QIiwgLW5vLXBpZSkKIAogIyBPbiBzMzkwLCBidWlsZCB0aGUg
dGVzdGNhc2VzIEtWTS1lbmFibGVkCi1wZ3N0ZS1vcHRpb24gPSAkKGNhbGwgdHJ5LXJ1biwgZWNo
byAnaW50IG1haW4oKSB7IHJldHVybiAwOyB9JyB8IFwKK3Bnc3RlLW9wdGlvbiA9ICQoY2FsbCB0
cnktcnVuLCBlY2hvICdpbnQgbWFpbih2b2lkKSB7IHJldHVybiAwOyB9JyB8IFwKIAkkKENDKSAt
V2Vycm9yIC1XbCQoY29tbWEpLS1zMzkwLXBnc3RlIC14IGMgLSAtbyAiJCRUTVAiLC1XbCQoY29t
bWEpLS1zMzkwLXBnc3RlKQogCiBMRExJQlMgKz0gLWxkbAotLSAKMi4zOS4wLnJjMS4yNTYuZzU0
ZmQ4MzUwYmQtZ29vZwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0
dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
