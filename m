Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDDB749A
	for <kvmarm@lists.linux.dev>; Mon,  5 Jun 2023 16:42:28 +0000 (UTC)
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-45d3e523a43so1651486e0c.2
        for <kvmarm@lists.linux.dev>; Mon, 05 Jun 2023 09:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685983347; x=1688575347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r7FCKK87DvKxeumyy9SDd2/SDnDekXDap0QpJp+wkJ0=;
        b=cWdp1XmK5svgOe4l0TjsaQ8jjivdFIm3dMhGNN479CW6NPGgwdIvsYcFL6mf501/0I
         trdXpgFP9MvAvz8docIpatqv/zl4OinM66kgjuqwoQnJX0IGuVQmhq+c8oRuCwfA1Xgs
         ax2TYDkeGC1/Yl5N38C3YTrAh1TWvKbQ0oKe2hHfgHgvxvNMM7nnY5Hakew+2s7isuuO
         7iIg7aIlSMz6+sX2eTUCxhMiux14eD271uYOeUvCiBawAXyqy3ptyJOGBfiRMiKdptG+
         oHwdZf5luJuYlTih6+rbnpEIHsXMXygRssPbxJL4PaxxWAGldQEvSD/Fs/bhKX3aZnke
         oZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685983347; x=1688575347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r7FCKK87DvKxeumyy9SDd2/SDnDekXDap0QpJp+wkJ0=;
        b=g6ul0VDcZk+6d+DXyU7856Mmlezi5FQ3om6UiOmkuPAbe/LHYifd5BoN1bIs8Am4BC
         fRljMVNC7rKRsxMUrK+LYPMRhF6B5HnvF9nSi+fHamaO+j2mMrHhYLQEnc4vYyBQBsn0
         cOYkABRBRTzAfasHtaL8Gpji+awgW7PrbuLYlr08v629vtiGOylSO9RX/doAj0RXcUpz
         fp2BIynQFTyinYbnPS6o8MdHCQ/VDK6jNRQHf5ioUIFgVwgI2Z9IWmWNAPOYFeehZrQQ
         4r4gjikcQbGrgcVWDQrLEUKN8EnsGfUmEVEONAOjzxvZXYTKaBIztO+2pTide3O5DgHX
         82qg==
X-Gm-Message-State: AC+VfDys8Qx6cUFG934EyQ1Lu7RbhYVDCHYHh7gX/u44/8hLrZj14Z+4
	gfJ8L8HkJtHccJJGU0GSmj3pKhfq32cW5dFN/kdE3g==
X-Google-Smtp-Source: ACHHUZ5aDqxqtFCwzCxAXkm7KOLQsjJTn5mGkQBeDWdNKAW515azAvtnqClsKAZnwGpKwxavXkJhAvvMTQivl+YRx0k=
X-Received: by 2002:a1f:48c1:0:b0:461:37d:dd3e with SMTP id
 v184-20020a1f48c1000000b00461037ddd3emr3540042vka.15.1685983346888; Mon, 05
 Jun 2023 09:42:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-3-amoorthy@google.com>
 <20230602203031.GK1234772@ls.amr.corp.intel.com>
In-Reply-To: <20230602203031.GK1234772@ls.amr.corp.intel.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Mon, 5 Jun 2023 09:41:48 -0700
Message-ID: <CAF7b7mp2kccagOipwZ_d+n6KEjY5zu=k3XVq0wZJ_GHvMqWqtg@mail.gmail.com>
Subject: Re: [PATCH v4 02/16] KVM: x86: Set vCPU exit reason to
 KVM_EXIT_UNKNOWN at the start of KVM_RUN
To: Isaku Yamahata <isaku.yamahata@gmail.com>, Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 2, 2023 at 1:30=E2=80=AFPM Isaku Yamahata <isaku.yamahata@gmail=
.com> wrote:
>
> As vmx code uses KVM_EXIT_UNKNOWN with hardware_exit_reason=3Dexit reason=
,
> Can we initialize hardware_exit_reason to -1.
> It's just in case.

Will do
