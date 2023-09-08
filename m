Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D341B64D
	for <kvmarm@lists.linux.dev>; Fri,  8 Sep 2023 22:29:50 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-59b59e1ac70so12985157b3.1
        for <kvmarm@lists.linux.dev>; Fri, 08 Sep 2023 15:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212189; x=1694816989; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iUDCny58mTjAasfc+MarJfyUNBk+L++E3fgqNSlzCZM=;
        b=Ms8n9AjFWPOrd5GfUmBO7Fs/usWpn7LWExfHhJ+d5g+uNqsYC9b9q9DU14mP6BokRJ
         OHU/TPoxWoHrO3aS334ODqa5vczap4EIx78IGAFw3CQwzXXBk5ZiQ39EgtzT6vu+5pks
         mKBM1+7u/VR70xUWM13UMJh6hdowdLUFJoNxXhkwfbYKKxuvPSsjsnAdnT5lMDfW6pUE
         bV2/CAqxJ4rIg0Tl8btpTNWsXnBQvnhS0Z65slD25zVuJXw20R7NIt9u0jTBe7Ivca4I
         k6K5uz9PYjQbb7NbV4L+g8t5PcFnR3/siDSNdylANPiDGTa0jwpHoihQNirkLa1rR4Uu
         uVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212189; x=1694816989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iUDCny58mTjAasfc+MarJfyUNBk+L++E3fgqNSlzCZM=;
        b=Jg3d8Tu74EyfCjitDcErqX6j16DOlLctdgE7KGR3E/8F5/TskIXqL4wzuK4BjIkAwa
         2TX0AKjBUNPpcG0x6xy2a/mLk0ih4k0V+ozArvJnkLrhb/m7GSEXzqynDGaDVhEztzDI
         PKg8UWCgqEjPNJyo10IcUCOuhfHFyuFlCEDbGBhcU1iyybIVf7Bl/YpZZGzg/K1mIpHE
         UgFER0DnwwBnKhWIXTyx9iKCgsEXkgR5OhrQk5MTZ31rhfFp6Em9/QYMnvixeS5W6oNE
         zErukmrYWpioipjmM5RVQj+vJgn+hG25mKJ4L4RLz/KwVDLdiFQke2T4AHP8yR866Hoc
         lr2Q==
X-Gm-Message-State: AOJu0Yzhax9xaw/3UiLeLBrIFBFoVNvU6pbsFWbPdjiOYJbjS0d1GEyc
	jItJ03VIsY7ma4vxUcB9HE1iKZbM7TYG4Q==
X-Google-Smtp-Source: AGHT+IEDvILkGVKALVwPWgXNiW3g6dYyieYFxOwYXxGieU/y+z8cJi+9eCRUi/zrcXi4OV1bNd39rVDx4ol+Xg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:df13:0:b0:d7f:d239:596 with SMTP id
 w19-20020a25df13000000b00d7fd2390596mr82253ybg.0.1694212189354; Fri, 08 Sep
 2023 15:29:49 -0700 (PDT)
Date: Fri,  8 Sep 2023 22:28:48 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-2-amoorthy@google.com>
Subject: [PATCH v5 01/17] KVM: Clarify documentation of hva_to_pfn()'s
 'atomic' parameter
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, amoorthy@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

The current docstring can be read as "atomic -> allowed to sleep," when
in fact the intended statement is "atomic -> NOT allowed to sleep." Make
that clearer in the docstring.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d63cf1c4f5a7..84e90ed3a134 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2669,7 +2669,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 /*
  * Pin guest page in memory and return its pfn.
  * @addr: host virtual address which maps memory to the guest
- * @atomic: whether this function can sleep
+ * @atomic: whether this function is forbidden from sleeping
  * @interruptible: whether the process can be interrupted by non-fatal signals
  * @async: whether this function need to wait IO complete if the
  *         host page is not in the memory
-- 
2.42.0.283.g2d96d420d3-goog

