Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16836FC3
	for <kvmarm@lists.linux.dev>; Mon,  5 Jun 2023 16:37:59 +0000 (UTC)
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-45d59140bbdso1602717e0c.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Jun 2023 09:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685983078; x=1688575078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4GNtd8GQvgY7F2DHMM4zSSgC1V5KrK5LXShf2LAeh84=;
        b=d2cXwO6omaKLj3TF9XVq42fESQt6+RQeekobXZ3VLELNJjnmF8bzV6YiWcQXD3lgff
         T2ptMjKduZIcL5qCXwy5pJu/kHGFr51p9HipIihz0ZAukNUamMMZNQX5J+i/HIMZUGiJ
         CvnHGSY8mvwLCKP9N/q17/Gfs635PLDQP/xBZvMc4Lui+GVcCNojooh3m8J2ARU2bHfr
         QEmjAKUAxa9nosqwQdDgc8KKYTu06Gcr5IrgkkdMHAlAPbaNsYgL/4cEnuVbqtG4Vfzh
         vVUafCE2L2MJG7oTOhqvRw53McZSvssVCd5PHYG6acX1sVyO2seLRQvisOePwPyTjwkk
         ykMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685983078; x=1688575078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4GNtd8GQvgY7F2DHMM4zSSgC1V5KrK5LXShf2LAeh84=;
        b=S/eNeBYyBcQHLCOoAQVAy+ChHkAmoZrMKLBXmcw0saw8MFmIJUi+/3J6uXPZ6M12LD
         ipp0e5u4SX62deFDr8N3E4zW+lmsPYMKBWeUpuYfsbajaOh1MbdWOYGvA7cm0qLKmnFV
         mZSARSI/oiCo7vscFi8HyyG3iSZV8mdLJH7D0+bkTQrfrgU6mr4o0UFTrOsPjGjO1tW6
         FZeItS6s8alyjBBgCaWKjVYMUIUA287gvx9uzApohhF5z43Uk2KiVCnpAlK1aoqIH3e4
         FkAbGtbmVDAq+lJ8HRTR0DNcy8wNaSckK+w6bglgNsAjJwK/kkImH/fRP8GI9hyhh4SI
         RbVw==
X-Gm-Message-State: AC+VfDzmWhXfzrezLf5Zmlhbr+AWRKl9aYxTlZ1mwOM5feVbJ6Gr7qlg
	AxkclnKtjWMIsA/zkSPrwExHzHfKtvOj+XUxghWPRw==
X-Google-Smtp-Source: ACHHUZ4gRpc6q7ReKbOOrt1DjQ8GOTzV3ROA2uR3fx5vrGDFukKvNPNd5Diam8tM0+WDBgl5vbrCCsJcsYbVUu0r+C8=
X-Received: by 2002:a1f:bd55:0:b0:45c:b73c:260c with SMTP id
 n82-20020a1fbd55000000b0045cb73c260cmr5834715vkf.12.1685983078309; Mon, 05
 Jun 2023 09:37:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <20230603165802.GL1234772@ls.amr.corp.intel.com>
In-Reply-To: <20230603165802.GL1234772@ls.amr.corp.intel.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Mon, 5 Jun 2023 09:37:19 -0700
Message-ID: <CAF7b7mr+suxFe63GXJWMK_XX8J1kp5Pi2yg_bNUi_0h0ub_4Jw@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To: Isaku Yamahata <isaku.yamahata@gmail.com>
Cc: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 3, 2023 at 9:58=E2=80=AFAM Isaku Yamahata <isaku.yamahata@gmail=
.com> wrote:
>
> UPM or gmem uses size instead of len. Personally I don't have any strong
> preference.  It's better to converge. (or use union to accept both?)

I like "len" because to me it implies a contiguous range, whereas
"size" does not: but it's a minor thing. Converging does seem good
though.
