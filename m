Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F8C126F06
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261492; cv=none; b=kMU61jPjiIyP5eAIQBueKD8XkfiZgf9PvQciHw4LSbnVDfgtINVOrA3NpsfDvNUqXNMvYTzESbLjERGGKtea0f+s7w3tvwLUkB99zOQo55FLm8WzbCYzBRIn2vCegbhjF7I/aO7YN+UYp2p/GWtmuIljkduGoDpIXDWtx758ysY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261492; c=relaxed/simple;
	bh=q+WrVR6GWMcaLogfLCjCJMlmw4N1tsyBz9zugyOUtkw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CSt+R2PEmPNw/2DDfy6rHp2o48stj/1rTTJAjDgAs2RShORKKdefKX30VYCFqeQscD/m81wn8oVC2u65g0Jg9vvAPphB6RZDA5xTbUoZURFGTODddK/iCCFpKnqIuYnwNc9llvNMrARQs297EPtu0DjGYU7iCeIyMdCynWJBifc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lvrDWDFB; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lvrDWDFB"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-343c86edeb7so2750781f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261490; x=1713866290; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UH5Xd73bWF09e5O1tnTBnTHYHcXgMzHG7suLObG1x3E=;
        b=lvrDWDFBCurLoqimnef5MHrCOJ5CErQlgDikJYsmeRpNJhxNI2kcNSCebTkMz8kaD8
         EOoTB27vdbSDkErwo8WOTb+51oJ+YJcsB0CtPcX4lIFZFWGaSvy6Sn0LgarZLZOHHJXy
         +tMg9OaQjGY+t3FXYXtjFHuVPqTLZ0b+mYuQGIofeeqImHasRaJJ3ze2hiydgA6b25pM
         ZCeMZFTdHV6PGGoPFk8+3O2Ez2izgtUS9if8JpEaZpu7joA8eEUilfp3Uwkxo1Ruo4IZ
         Jklu2Fhr2P0zGl599JboWVYVATjwmu7pQDrA41Tg7LLLw7WOHzGVQh3KVc+JK9sbn+jH
         4Lvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261490; x=1713866290;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UH5Xd73bWF09e5O1tnTBnTHYHcXgMzHG7suLObG1x3E=;
        b=hAWYRSZdu8FPyEJ4J7Q+baMB/xO+PXYFIWAzLKi5QpK51h8IVO8x5L6OUSZZefPU9Y
         BmAAugoLg0SwUD/1hMcQSz9OYg6vpqM0vFmUnTSLZ+EfvEQVeffrrx+azMg2JFnb9Wou
         Jla9HRSM0Hx94mRF+BAzVz99euPN1OU2bhZnMvg04sUjvv0EKhACeq6XS9iKQ5u+2sND
         JRq8CNHTX8J0583JF/KBCzY3G+/l5CCOa6wEfqB7AfnDgUk7dusyqkOH9QvLAQH5NlAA
         ZJ9gbRAH4Uvfl12tQEHWwFS7hD2zoUkGqfr2wEbEho5QZI3EvivFTBQj3mfaSqU+AxCt
         h2mQ==
X-Gm-Message-State: AOJu0Yx7G6mroMYsntolF4mb270njxa6xzRlXMyanU0kjtAdBmF5+bo9
	qXfmEjrRuzK5laVTSlrRq4se4Bgcrw6JjvK9pBya3uXOI6EdK0WFSQbXosZSIKXXHdmhvCo0dqx
	PgUq2bss7li+7YNa1uwhUmvxQzx7mttSOwoZ4lWWB80Xa0h5c8BXp8TKzf5mhpsBR5Pk4OBOu5Y
	2ko7cFvnI67E9OnNo+FzHdFIPvdcE=
X-Google-Smtp-Source: AGHT+IFb/glC7sla4zG6bMoUbTaRP2SXUHDZsenB5tasvFVADXP+V7M32wt5nEtz3VRE8a6FbPltijif1g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:fe04:0:b0:346:b0b0:e2f2 with SMTP id
 n4-20020adffe04000000b00346b0b0e2f2mr23814wrr.2.1713261489844; Tue, 16 Apr
 2024 02:58:09 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:30 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-40-tabba@google.com>
Subject: [PATCH v2 39/47] KVM: arm64: Do not support MTE for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Return an error (-EINVAL) if trying to enable MTE on a protected
vm. MTE is still not supported in KVM in general. This check
ensures that pKVM isn't caught off-guard when that support is
added to KVM.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index edb321594505..cddb4c3061cb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -86,7 +86,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	case KVM_CAP_ARM_MTE:
 		mutex_lock(&kvm->lock);
-		if (!system_supports_mte() || kvm->created_vcpus) {
+		if (!system_supports_mte() ||
+		    kvm_vm_is_protected(kvm) ||
+		    kvm->created_vcpus) {
 			r = -EINVAL;
 		} else {
 			r = 0;
-- 
2.44.0.683.g7961c838ac-goog

