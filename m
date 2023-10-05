Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F08C1112
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 01:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fL1kIYFh"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5a22eb73cb3so5930467b3.3
        for <kvmarm@lists.linux.dev>; Wed, 04 Oct 2023 18:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696469195; x=1697073995; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pAYXXZZrtq6qVtd9bBLCof1AkK8uP0CzKodj/aevUuM=;
        b=fL1kIYFhGjUmVfbRjfMBOoaM2eXoTN0aV65RuN44H0PmiEEXxgqZL8siIWIjDaOVac
         ssFaEOgOTEeyYdzVgUIEoZc5wy8uTwyTsqgywfgziVMO1OZkrAE0MndydJ76Sr07VY6B
         YGajee/EKf9kJSFCIzmRy2XLFuLn8Pp8l/qhUZXgYfZSmi9+OY/1z5k4A/wQ/f7bK68Q
         Xa2o+iXrz8yj70EhPyevA1rPwt2rG9WRaly/uL/VFZ7QbxF+aBdsMrr5BD5skfkpnHoH
         lKwVEOGf3MSujgMAweDJYmO1naUqQdMUbpyuXoEHm049pUrLLOgQ1OYZt976SQTiZfLR
         zUYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696469195; x=1697073995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pAYXXZZrtq6qVtd9bBLCof1AkK8uP0CzKodj/aevUuM=;
        b=f3Ug0OHgZwW5tnBtJQRXbQiDir8cbjnWO5OZ7cq7rNrRIQb8H/BcCTzME9q/shXOme
         awl7ELsVLKd3UU30EgvTNiDOrs3ulEhCwIF2Ar60Rop+kWvQ25z4ngodaHSrFSyCTQUm
         W7i/NJq1OMgR8DRzWK6OlILzCIfvEPuN5B3RLrq/TzyW340I57iksfqy4G9e40q1Ur2T
         cg9fU6nwwOnTdGadPv45S1rvqgRu8Yj5gMGzLYZ1ovpFL86wN698cJMGg8Nyy09VeTmn
         md7Ai8QZDw7/JNWFEZrA4HpYdcPy8+tz+uMmw0/j1RzSaVNHv5uA6kySpyeMOjECk8c2
         GORQ==
X-Gm-Message-State: AOJu0YxkUdOq2rRppP+7e0fUG+bbNGj42N3W9NLe+NM+WmHlEMHvYiDs
	ClHFaVh3DzCErpc9IqqFAlKGQojQw/U=
X-Google-Smtp-Source: AGHT+IE4tvEFWYdA+2STjnyOz4sD7+XQagXBrtdo4DeeBBCeS2cJcL9Ogqq1easuFZmclPalNjWAGSxhH6g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b2c6:0:b0:586:a58d:2e24 with SMTP id
 q189-20020a81b2c6000000b00586a58d2e24mr79019ywh.5.1696469195294; Wed, 04 Oct
 2023 18:26:35 -0700 (PDT)
Date: Wed, 4 Oct 2023 18:26:34 -0700
In-Reply-To: <20230908222905.1321305-8-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-8-amoorthy@google.com>
Message-ID: <ZR4QyijDUsMX40U8@google.com>
Subject: Re: [PATCH v5 07/17] KVM: arm64: Annotate -EFAULT from user_mem_abort()
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 08, 2023, Anish Moorthy wrote:
> Implement KVM_CAP_MEMORY_FAULT_INFO for guest access failure in
> user_mem_abort().

Same comments as the x86 patch, this is way too terse.
