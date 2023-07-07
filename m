Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF395381
	for <kvmarm@lists.linux.dev>; Fri,  7 Jul 2023 17:33:55 +0000 (UTC)
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-794cddcab71so821482241.1
        for <kvmarm@lists.linux.dev>; Fri, 07 Jul 2023 10:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688751234; x=1691343234;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4mMOiGGWfSgQUV0NfkWe8yufDp7AyZbYXXdDzBmEvKU=;
        b=MAxHnYzA5EIjqml/WSQZK9Z1mksPsbZAJHdmddPeh2/2igAnmPHbJ5HPh4QZUQ0PsP
         vqqf8k26Sq0Pzr35rpBA8DgbyvNkgiqg6igQ3FGsefgG/13OJSJN39hx1yMhGPDuv/dS
         yg0ynhkrO7u6yhbLyTYUEnxP2bJnrZamJM5eGrMpQgT0Z4rQFROxYX49gtSMZd7lOYfx
         YRZth89KBr0tlZzJ6Gw5V3dnesBunFf4C6YkRB0F8JnL5Jb0g08+0vWZ0feY3FWK893z
         0NTj2DXKwA4CifwoAtVmicBXZwSoLBLS+OG+a/t5sIF70DemdUMjxMbArHBKNO85JgZ9
         HtjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688751234; x=1691343234;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4mMOiGGWfSgQUV0NfkWe8yufDp7AyZbYXXdDzBmEvKU=;
        b=fw5M1U8Eg7bPTmZsgnZf4oe5GGiCAbJvzXo32arsfimj6RBTXrI2TNBoDZj1/L19Dz
         bJ3RTihLJNCqKhEhoWfF1lLfr0/JxIW8ixoChoET+peDq59EnKRTSVa2BPkce1zzyfIQ
         f/h/IYZ6//utkcxP/FyCUAd8wW3CsNXGWk4Q5ss0bRFuDwJwqFNlI4pzQpwAkzlbQSWQ
         LXXt15L/21YKJEjvdxv/2tbg4HEi9TgRzefE2kXZYDykv11b8smfr2YmHEdwEFmpRQbS
         F2/gebfhmCogHGAiBXsRgJzPvEDvOkf3+Zo9/siZy47nx+xdwKVR627Hsv+/JX2eNWI4
         Y4IQ==
X-Gm-Message-State: ABy/qLaF3edx11W514ui3B4qeM8AovoszGt6Tc81lpRJUeCsoPxj0jr/
	QDhC5XsXxoItIjkok5+PkC7n79yyH0msiAseQybiKg==
X-Google-Smtp-Source: APBJJlFR4KNOJRbrQtlj8C2ws1LLrgKjQ8Vx35fAKhuAVMV1LErH4cOIuWnQm1EVnoRsJ6LuuI0NyqvlgSBWdFbbjO4=
X-Received: by 2002:a1f:3d11:0:b0:471:875d:598e with SMTP id
 k17-20020a1f3d11000000b00471875d598emr3772263vka.14.1688751233855; Fri, 07
 Jul 2023 10:33:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-8-amoorthy@google.com>
 <ZIoUc2hLd0zMOhO+@google.com>
In-Reply-To: <ZIoUc2hLd0zMOhO+@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Fri, 7 Jul 2023 10:33:18 -0700
Message-ID: <CAF7b7mrDH4Y+uWPW9kxL==i1LDURMHdNv+maFj_PH7jwPb3JwQ@mail.gmail.com>
Subject: Re: [PATCH v4 07/16] KVM: Simplify error handling in __gfn_to_pfn_memslot()
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"

Done

(somebody please let me know if these short "ack"/"done" messages are
frowned upon btw. Nobody's complained about it so far, but I'm not
sure if people consider it spam)
