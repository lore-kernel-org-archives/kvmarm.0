Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D421FD5
	for <kvmarm@lists.linux.dev>; Sat, 10 Jun 2023 08:33:12 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-25bb2c4c2c0so192537a91.3
        for <kvmarm@lists.linux.dev>; Sat, 10 Jun 2023 01:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686385992; x=1688977992;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NYoHCJVN5Ws4WOWwh0nDBJ62B543NnoGs0VnfPoL2AE=;
        b=OarbgxLj+wBHWXNQl/kUWGyZLvdQikw3cGvbVjqyavaLHQPyHru6Op4yKHyaklO7Iy
         dI+9Y4vlpp5qoDkZVO7JozeMTBgzhyfP7q5859TNXKGsAhVKFe7PS41b1M0A+jGKIqgb
         clxmh2NoCiLJdeVd2PpOkqgHlXdHAfD4sE9tHCqNxs4uXNjw8MzvNF/TtfCjvBG833C0
         KB7Tv1ojfsY5Xq63i8/6wnE5vdVA9znWEUIIzvzCZAMM2tojx1DoRXTy2Cdz7ZLkNPow
         s/aTpPbr+ll7GF4JVatzdVrGipPhwY1nTq7bHzJsTASO6nnLgMXg61+UANfpxHu9XG5R
         TtLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686385992; x=1688977992;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NYoHCJVN5Ws4WOWwh0nDBJ62B543NnoGs0VnfPoL2AE=;
        b=ct3zdy6MWTor11/LDkckXxdLPsUeNeXKDuGakxBsdw0ITmBfpUkFXZHzjRnKQn8dPJ
         FYYQsI4t1z2HGBuGmk9yzFXyQ4WQ7hDaer7qLw7QZoDrhmNbgKYgOIz+lxBHkcSeN1rB
         zvQ2bS/tCQHzF3x2TW1iIBVSMmWVDVvIPj5hACibVzHuCf3k3ht7RHSddIpwOPqdX/z+
         A34UI7XNBjYWLblC3VPgF7ukq39c5qS0szteQ9tEyeEfIYAN/4K5f3ysnwGAPG7Dhp+n
         ThjDLUbjDbb0b+e5egyaHwPpRXmXIoPrQ6GQ8A+pKzR7fBiiX5qpmbdYOuXQ82jKEVwx
         YsSg==
X-Gm-Message-State: AC+VfDxNO1Q6XC05ux06IN1VJIglo3nZCjmiL0NRkoDKWE3dBe0/G7mR
	WYKHow9RVdqPctj4Kbwk9as=
X-Google-Smtp-Source: ACHHUZ684F1hJ5dJXKAerRauMVuPEsNirNwFulp07Uv6rNCgaT4y3BcN9JXQfx/9bXl6VQTXSEw+pA==
X-Received: by 2002:a17:90b:4b91:b0:255:2dde:17cc with SMTP id lr17-20020a17090b4b9100b002552dde17ccmr3411605pjb.47.1686385991971;
        Sat, 10 Jun 2023 01:33:11 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id b15-20020a17090a010f00b00256799877ffsm4262532pjb.47.2023.06.10.01.33.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Jun 2023 01:33:11 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230530160924.82158-1-nikos.nikoleris@arm.com>
Date: Sat, 10 Jun 2023 01:32:59 -0700
Cc: kvm@vger.kernel.org,
 kvmarm@lists.linux.dev,
 andrew.jones@linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>,
 alexandru.elisei@arm.com,
 ricarkol@google.com,
 shahuang@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <CC2B570B-9EE0-4686-ADF3-82D1ECDD5D8A@gmail.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
To: Nikos Nikoleris <nikos.nikoleris@arm.com>
X-Mailer: Apple Mail (2.3731.600.7)


> On May 30, 2023, at 9:08 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> =
wrote:
>=20
> Hello,
>=20
> This series adds initial support for building arm64 tests as EFI
> apps and running them under QEMU. Much like x86_64, we import external
> dependencies from gnu-efi and adapt them to work with types and other
> assumptions from kvm-unit-tests. In addition, this series adds support
> for enumerating parts of the system using ACPI.

Just an issue I encountered, which I am not sure is arm64 specific:

All the printf=E2=80=99s in efi_main() are before current_thread_info() =
is
initialized (or even memset=E2=80=99d to zero, as done in setup_efi).

But printf() calls puts() which checks if mmu_enabled(). And
mmu_enabled() uses is_user() and current_thread_info()->cpu, both
of which read uninitialized data from current_thread_info().

IOW: Any printf in efi_main() can cause a crash.

