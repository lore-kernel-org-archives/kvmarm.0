Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD717E
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 20:46:10 +0000 (UTC)
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-3f6a6e9d90dso67321cf.0
        for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 13:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685479570; x=1688071570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pr06SdwCclh2zvxEhUJpXnyPxEiUxaGZRfUn2lWDHfU=;
        b=wgszgCOPzKS/eLro6ja1PmQxsYOjUp8PXM+Swi1b3geif0q8T060pvy1gMVwZtfWOb
         FL9Tyf7b94KpPgOcaGyP5nDYKVAdBX0Re8BzliJbAyEnFwK4+on/hFIxNzGVI9sNMlZs
         MJSXy3b/lOvM5bWZINlP/C4SXsd3dicw63NsJOgHjejKWFPeqv5yMrNe19Rwk9Ii+D7+
         8d6HpD7AbKBen6lc9A+Y2h1hljftzsr8SEcPBnTph3dwlNHc+XDVuR7fm6hrxDsgQYQ+
         GJ0vud2oNQjSJEmbKTgRkKejRzquMcW1dBRk6kQUmZgDudEZ879dggOnwPfpjOD6F5y4
         oZJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685479570; x=1688071570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pr06SdwCclh2zvxEhUJpXnyPxEiUxaGZRfUn2lWDHfU=;
        b=PX5WDXO0+uQIRsJyzJXVNHXwVuNd2haIPSF5QlrV4cVaJhYCqC69DZzrvaYpRQrUFj
         RKg/W0hRmf3m4bbgS5Qin5yHoO+8GLuNEAUGVajl2go5NZ/6YPp4RLs2cNxvc02s+XO2
         F24m+TW1nJRN5Wr+FW0xJ5h0gI8MN8t2YfrEZnh68liIA8dREf3+fZz1aJI56w8bRbw8
         8uClnkcGrMNaWQ35gEer3jNuhXQyu8T5swsPZ7LXBD7xOGJzqsVgi110DTfqCOpa6rjf
         PyQUzsk650enDXO6THlAJkg4GL2+6av7DoZ/BaJd7bvPFdZ5H5b1KhkfqNyTtmqAwMtb
         2pDQ==
X-Gm-Message-State: AC+VfDwEX9X2U4jqVAkRicN6ZYixUjjfeqkuZWGsZ3SZc4VpcCYwdIIO
	UyNccLQhMNSBY6/75iAyQvDjW/TOStTs0WMXTcLzrg==
X-Google-Smtp-Source: ACHHUZ4jJZKLPPo4/StebD/Mknpi3tNY4VHMroMJx9drsU138Agu7XkXbVs4RIR2E01Thou8y3+90/FSSZVQUAlewLU=
X-Received: by 2002:ac8:7e8c:0:b0:3e8:684b:195d with SMTP id
 w12-20020ac87e8c000000b003e8684b195dmr20043qtj.10.1685479569818; Tue, 30 May
 2023 13:46:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230530193213.1663411-1-oliver.upton@linux.dev>
In-Reply-To: <20230530193213.1663411-1-oliver.upton@linux.dev>
From: Yu Zhao <yuzhao@google.com>
Date: Tue, 30 May 2023 14:45:33 -0600
Message-ID: <CAOUHufbUNhnYKqHAffcM82hyJp0vgfFWmFkhzyrx_W4rkGbgkg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Drop last page ref in kvm_pgtable_stage2_free_removed()
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 30, 2023 at 1:32=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> The reference count on page table allocations is increased for every
> 'counted' PTE (valid or donated) in the table in addition to the initial
> reference from ->zalloc_page(). kvm_pgtable_stage2_free_removed() fails
> to drop the last reference on the root of the table walk, meaning we
> leak memory.
>
> Fix it by dropping the last reference after the free walker returns,
> at which point all references for 'counted' PTEs have been released.
>
> Cc: stable@vger.kernel.org
> Fixes: 5c359cca1faf ("KVM: arm64: Tear down unlinked stage-2 subtree afte=
r break-before-make")
> Reported-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Tested-by: Yu Zhao <yuzhao@google.com>
