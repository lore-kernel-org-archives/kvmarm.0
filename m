Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95381114
	for <kvmarm@lists.linux.dev>; Sat, 10 Jun 2023 01:17:38 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-53fb4ee9ba1so1039269a12.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Jun 2023 18:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686359858; x=1688951858;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X6lKVuvUc71IPN4PDHC+H65W3OZBdepXzHzvvlHzhg8=;
        b=ZKgA90zryEFhJggHNRcydoQkhATnssECBpq0hoQqLL/EMEXHYYVKbklC5dP0MkGUi6
         HFfZRF7fYCckQIhI4dJJ5CU0e3f9m4xZ5bVzes/PsVlpHRAwnGWZ7tMaC8WtHADBHlY0
         SMEPd67AaAz0Im5pygzz0AAZP4Qq1PhAPu8CpgPd6QK+ZIdFTyGUfvIX7rNPJNu4Yfve
         nf/1O9S+FM2ngGcXYBukU2r2nW8omJOJ3s3bywauM4k98kKKON1b6wr4eXAj5GL3sqzY
         5LWHBqQ0PIL6nYHlGjMv+G9qFWwWKn30MAKAPoSxIgEcgEZWeB6oNe6ufZ0ObcdQuQI1
         Bsnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686359858; x=1688951858;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X6lKVuvUc71IPN4PDHC+H65W3OZBdepXzHzvvlHzhg8=;
        b=gb2swG90k2eW0RKvotiAKOzOQkwa/lHiPJbXoijgJIjdXVV/2TjatUqjXhrKu02FsA
         HT/mYV6F/RDE27nWOiYjMHuligFXj+3hYN+wPBHl8b6Rqp1qbGT17Ecy2XQFTSoVY0EE
         zoZi+l/YVB38P9bAjBE1y/3iQLzmjSUddYmRV6RpSSjkqZSwYGMWRuq4vyam1YgY7+vX
         CyvzENEeTUMTNbM7GI5Yu+zcrLTY25gSIvud/odVeO5D+uWYn0qIQQBsdawNWKgYHuDe
         DPNWMqRe6aMTPUgdC+8HSYEzEq3acqplBSCRzfU2qiomftPxnSFK75Qkmk5TPW9/NsKe
         F9og==
X-Gm-Message-State: AC+VfDxG75RgAOb8YmgkQ1WT0GNNDWKV66delbDvyHDc3dDbxHzg2gPc
	bneZZGBwdCDSXMXPy7DDxEiZOG4J6bU=
X-Google-Smtp-Source: ACHHUZ4B9TocPQJmi77aEf7J+wtJVDWXKUGFB11GmDOHvlHtgojDEqQQOWrhuF0RW+CIMlCOhfs1kA==
X-Received: by 2002:a17:902:c943:b0:1b2:a63:9587 with SMTP id i3-20020a170902c94300b001b20a639587mr510272pla.36.1686359857847;
        Fri, 09 Jun 2023 18:17:37 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id ja11-20020a170902efcb00b001b016313b1dsm3855729plb.86.2023.06.09.18.17.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Jun 2023 18:17:37 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v6 23/32] arm64: Add a setup sequence for
 systems that boot through EFI
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230530160924.82158-24-nikos.nikoleris@arm.com>
Date: Fri, 9 Jun 2023 18:17:25 -0700
Cc: kvm@vger.kernel.org,
 kvmarm@lists.linux.dev,
 andrew.jones@linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>,
 alexandru.elisei@arm.com,
 ricarkol@google.com,
 shahuang@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <A5775A3C-B8BF-44C0-931A-CA2C9A4A0A4D@gmail.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-24-nikos.nikoleris@arm.com>
To: Nikos Nikoleris <nikos.nikoleris@arm.com>
X-Mailer: Apple Mail (2.3731.600.7)

>=20
>=20
> On May 30, 2023, at 9:09 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> =
wrote:
>=20
> +static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
> +{
> +   int i;
> +   unsigned long free_mem_pages =3D 0;
> +   unsigned long free_mem_start =3D 0;
> +   struct efi_boot_memmap *map =3D &(efi_bootinfo->mem_map);
> +   efi_memory_desc_t *buffer =3D *map->map;
> +   efi_memory_desc_t *d =3D NULL;
> +   phys_addr_t base, top;
> +   struct mem_region r;
> +   uintptr_t text =3D (uintptr_t)&_text, etext =3D =
__ALIGN((uintptr_t)&_etext, 4096);
> +   uintptr_t data =3D (uintptr_t)&_data, edata =3D =
__ALIGN((uintptr_t)&_edata, 4096);

I am not a fan of the initialization of multiple variables in one line.

But that=E2=80=99s not the issue I am complaining about...

Shouldn't it be ALIGN() instead of __ALIGN() ?

