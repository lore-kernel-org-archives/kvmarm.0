Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5B3146004
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 23:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041257; cv=none; b=BYVK2JCfLRfc9JjGvo939Wph+x700pj3pxcdkvT44Nod4wQ+wop8iXEkufiI3aPjiq41GLAorjhWje7++d4vLTka+tl3H1GWE4mmAeRUFT4J0+CclHpnIVTqFQA4jPObQcDsRF279GrhQkf3/tT1TrrN9pfx1muBRGc7V+oUsAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041257; c=relaxed/simple;
	bh=r2pWpzfAVdKs83bkb8yysRyBcLlfdbbrpFtdK+fTshk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C8elLeEsO9oEFqAkUPihMojC7ReOPOX28lg/p/Y2Yi3GadUfjEc79m6PBjuRkjPtEKdjPz4DTQHdoYtpoJpMWfuOS6QZotS64VTJHKbi7F5v4NjhgQgR7haB3RwEKR4jfIEqNX0C/mj4vKSf6Mc79iU4/ITQE3xokwnCD/fkYLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fxj4+wAk; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fxj4+wAk"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-607cef709dcso23359157b3.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 15:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041255; x=1708646055; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eziXXvGnuzc3MNfe8KeDVfyFrpM4nmh4XdH42oDvVIQ=;
        b=Fxj4+wAkFUnuQ3m7ZlrQSP+w6ELn+o1cv1/HfIKMBK1jL/OWBD5tLRCQneGCyX1HGD
         lNcCENv9FvaEQwyG5UbnkpMGL8GlP1Sxfg6VJwYx47K81ppbas6jmbnCwnJxxP8oBgpK
         w1AgxHNSkCAC5k+uOFr9EW05Ge9ayHPiA8LjeR6A9mf92yBYF74N2KmqXdnaL8/CS3bq
         HEMtJvcBoh35f4mKwl1TNp8JxFI+GwxKp6tppX99mifxju3xr7hM7KBMz1pGMLLAeA3P
         MxOCxvXlm81TN2b27ej4YsRDIe7l8pSZptSytuYlIZtzZ2qixo8dtMZ8khfKCfG2LA+7
         8fjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041255; x=1708646055;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eziXXvGnuzc3MNfe8KeDVfyFrpM4nmh4XdH42oDvVIQ=;
        b=Yh9Cfk3LClQ1gfoeY0FhBvOQNLfs4QtzveftrhVuLXcQvg1SlTXgeSMKoa5wb2KlTw
         8a4HfDmAORj2K6tEt/c5d7K+6lnGnCQNSvMg2rQ6+GJqAMUO5WUPlbyyZLGMPU73RDyo
         Tk0IZo+4J+JD0jC4Gxja5yhd2HTuX9ovYA7KzUEJconlM2zG9/3NUerccRP8VWpx6eit
         3dqQMThRmePgsCS9hhbuDdCkCECppy36xXjpMNlt4008r8K/N5etjyKq24UWrjICr5GN
         2pDGupNs+v0PzEZUeDdGvUUfjndPXW9gdH7UlbyneGfNWvP18sDxZtp9WcpSHCvmdRp5
         1eOA==
X-Forwarded-Encrypted: i=1; AJvYcCV93C9IZFOAXy1vzbjAw5s9WGkAAHDc0/7IaY87nAcqUZMB9rePJqTTA/tUnYkakpNrqydKWx41z4HUfQatCq0FG7cwcPrj
X-Gm-Message-State: AOJu0Yzz7I0U+CWLRoMT9p0CPmLQtMPv398R7rYna52Zh7qzVF+xDwjM
	JCWuUrSSHtHAEyFVVYu7hezFw9lkvNUNdvNLKDd4dmgC7MXgiD9soeMUD6FObxyqbkkqiXpc8TM
	C+Nt1i/upPQ==
X-Google-Smtp-Source: AGHT+IFww/v3CM+5seP7lyS6W1rnjeJciBbkYTG1sl3efm7OgTZ/7wSq8CJehcHQjIKBWPkZH378Co78DdrMgg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:705:b0:dc7:53a0:83ad with SMTP
 id k5-20020a056902070500b00dc753a083admr787010ybt.5.1708041255003; Thu, 15
 Feb 2024 15:54:15 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:55 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-5-amoorthy@google.com>
Subject: [PATCH v7 04/14] KVM: Simplify error handling in __gfn_to_pfn_memslot()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

KVM_HVA_ERR_RO_BAD satisfies kvm_is_error_hva(), so there's no need to
duplicate the "if (writable)" block. Fix this by bringing all
kvm_is_error_hva() cases under one conditional.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7186d301d617..67ca580a18c5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3031,15 +3031,13 @@ kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
 	if (hva)
 		*hva = addr;
 
-	if (addr == KVM_HVA_ERR_RO_BAD) {
-		if (writable)
-			*writable = false;
-		return KVM_PFN_ERR_RO_FAULT;
-	}
-
 	if (kvm_is_error_hva(addr)) {
 		if (writable)
 			*writable = false;
+
+		if (addr == KVM_HVA_ERR_RO_BAD)
+			return KVM_PFN_ERR_RO_FAULT;
+
 		return KVM_PFN_NOSLOT;
 	}
 
-- 
2.44.0.rc0.258.g7320e95886-goog

