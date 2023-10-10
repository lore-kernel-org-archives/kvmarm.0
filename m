Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BCB354E1
	for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 23:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sU2rBA7M"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-307d20548adso5684652f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Oct 2023 16:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696979827; x=1697584627; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EIjKveupCC73cR3+NCpTtLF6c9Fas/4Eu5RGdKgMqzY=;
        b=sU2rBA7Mw5bC+7Sx4m8UV9l5hIvdEqfJ82xu8T9C7gy/Ma+C7a/iyYn3dWuxk3YtYb
         cfRgksvGUjsHf7El89L8WY2bT4fZ75kbFLWI1aa3mMaY20BQe/nT1ArFTU+uIwDlE64G
         Xk5ll+q3UEO2YVZA21Mr3NqVzoudLXkeAHSFWKGsnFO1MofMV/OzBI1Y96+FILdShCBu
         2zh3IquOq06197KxqBkhj7EvFw3AI3wPxCFB/ryIemdbTBdVLqCD3yN1MJn19v3PkNIp
         5EW+L1dCxisNAGz2CLfGygbvirl6+IIWkiN0UzsCh198z7K7NR+I6UFIX4zOJEgDmNsb
         l3kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696979827; x=1697584627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EIjKveupCC73cR3+NCpTtLF6c9Fas/4Eu5RGdKgMqzY=;
        b=lc5kayjPPztV0gI7N9dfat4taS4fk2rVG6MeccSPWQi1FfmFPF6JhkYR5aM7f5fgHe
         Gq5Jd+s+oW/c8sZuc6GbUO+6QQ5nx1i4tG8RSEj0YnA+OHX89LBbbUak6l7a3WxJUkeF
         T5QggDS53JJZATMR9f+8loj8dkGn9dxlCUjJxUyU/rSlD12ncKBS6B4RHuBLk1/m6Dy7
         3UyzCZneHtoWmhcZosycoI7ObSajx7Ma5b+saHXLxpD/DmwAcq7x5yvWcDGoIY7+KQFj
         W8Jr83rlGfBDQqi9XUmncJZ8v7JKgbngVYD8sgghK6T5Sq995lKGhJ6MgrmuA4H5Vx2+
         xbWw==
X-Gm-Message-State: AOJu0YzdIuBuBovxEgWLmBBYlD2tt/cS451vrBS75+0nOgwztjWdZHRa
	G2BWruJ1JqPzGAfmvdmdpAe3yPkSX5LSLTz22f27uQ==
X-Google-Smtp-Source: AGHT+IHjix4DDviN0OKHAnA6wMPqxVL734sjSysWmwhkzJGmcQobD9amuMZACosgKD0dy8qkGg+a8jYHMlBO/2KAZjE=
X-Received: by 2002:a5d:5a06:0:b0:32d:23b7:49af with SMTP id
 bq6-20020a5d5a06000000b0032d23b749afmr3115151wrb.36.1696979827335; Tue, 10
 Oct 2023 16:17:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-10-amoorthy@google.com>
In-Reply-To: <20230908222905.1321305-10-amoorthy@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 10 Oct 2023 16:16:40 -0700
Message-ID: <CALzav=f8YDdqxVXNRASNWxuM2WzgBwj=hErj1Yc5da552ecG5Q@mail.gmail.com>
Subject: Re: [PATCH v5 09/17] KVM: Introduce KVM_CAP_USERFAULT_ON_MISSING
 without implementation
To: Anish Moorthy <amoorthy@google.com>
Cc: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, ricarkol@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 8, 2023 at 3:30=E2=80=AFPM Anish Moorthy <amoorthy@google.com> =
wrote:
>
> Add documentation, memslot flags, useful helper functions, and the
> definition of the capability. Implementation is provided in a subsequent
> commit.
>
> Memory fault exits on absent mappings are particularly useful for
> userfaultfd-based postcopy live migration, where contention within uffd
> can lead to slowness When many vCPUs fault on a single uffd/vma.
> Bypassing the uffd entirely by returning information directly to the
> vCPU via an exit avoids contention and can greatly improves the fault
> rate.
>
> Suggested-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 28 +++++++++++++++++++++++++---
>  include/linux/kvm_host.h       |  9 +++++++++
>  include/uapi/linux/kvm.h       |  2 ++
>  tools/include/uapi/linux/kvm.h |  1 +
>  virt/kvm/Kconfig               |  3 +++
>  virt/kvm/kvm_main.c            |  5 +++++
>  6 files changed, 45 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index 92fd3faa6bab..c2eaacb6dc63 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1312,6 +1312,7 @@ yet and must be cleared on entry.
>    /* for kvm_userspace_memory_region::flags */
>    #define KVM_MEM_LOG_DIRTY_PAGES      (1UL << 0)
>    #define KVM_MEM_READONLY     (1UL << 1)
> +  #define KVM_MEM_USERFAULT_ON_MISSING  (1UL << 2)

Bike Shedding! Maybe KVM_MEM_EXIT_ON_MISSING? "Exiting" has concrete
meaning in the KVM UAPI whereas "userfault" doesn't and could suggest
going through userfaultfd, which is the opposite of what this
capability is doing.
