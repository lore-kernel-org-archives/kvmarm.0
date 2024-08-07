Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA3F12C460
	for <kvmarm@lists.linux.dev>; Wed,  7 Aug 2024 15:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723044566; cv=none; b=CKqByR7krSdowWD3FqccMjuFP22hXecU28gfiHJZY22CbAda8NoQDTgfJLdG27kA/7cjMwziuqVvAzoniOwOYiV2LGtzTdLS2Vs3poC4Ii76MG1tKfM810iJGBMO28i87Mb0TqCdF8PlGRANSE9YgtzINhQ1dcVHACA3l9AgzyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723044566; c=relaxed/simple;
	bh=B3qUjQUBKSoj6DiE5izmtCoNi2oQX3kGXMYImbc+tBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j8UcAS1xXut0wjiAOs6CWC/skUK27sxTt7IzijQxv5QhrQ/bjb/kwPl2+tulbhjR6fkE09U7wcnZr5LyLFZ7hoQAA+nFUSya3pYee+J5yXWKjplkWmXz8BzlTfRhUcVj/pCXsET5AAH9T+du59xkPXAnWJFGNMSujyLIfr6g/xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=Dm5zARmO; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="Dm5zARmO"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e0bfd14aff7so1692523276.3
        for <kvmarm@lists.linux.dev>; Wed, 07 Aug 2024 08:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1723044563; x=1723649363; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XKQ9M/o3NVnkKygQpCqhb1IVgEtJMwyJqqnPTlCGvnU=;
        b=Dm5zARmO7s658Ejq6M8LHiXWSjoCLEZCO534I6lbpxaA9dUhWbRqoMLqylrq81GgBP
         Uc3s8CBs45i7V6l/2g5bGAPSGVasP9soqwOTylMQErtU7fd/37EmlJPNJfuNj7ZTdV9C
         OV/LFaMc37w5YqQTE5uwfN7I+Qm3Qgt02imvNnzaafgQVwTlo/nEGgt+P2jPlh7xquni
         cktdlFODWVRCvhLgLngI8T1GgU3Y+nRNPGFpOcpIKyeQqUCM0jhywQNSSVEMYzIF6JC9
         BIJsdGKB7bFFqy4PQqhq0P6iUGitTvjnbipZpALbVgYBk17U8ZuRUtP58NbqH1/xtWUq
         HHXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723044563; x=1723649363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XKQ9M/o3NVnkKygQpCqhb1IVgEtJMwyJqqnPTlCGvnU=;
        b=PCWOS1ul/0YemTFrb/mfVfJnI5NTLkjV4ybWQIE1ye2ril7zF7iwsmqs149eX1fwbI
         tWY92izz+o2wr92qeDmDVcFIl3aAUYX/xKl7dsDSDChZgzmqGcbg05XJx1MPyaBbkl5M
         cLpMykWd+g4Hix/4rfFyYXUU6LBKOwJ2dqBFIh/H8YU01eATH7wPvtHOxX/Soo06ZKPq
         njsYXEdyLeBml+JWOMBztLFKX0yeSpoI+aYXtIMJ6kTYup0xdSpNaOSB4xJjkJjA8hGh
         hscU8NclgKGJ6V3cl2dEccLNYaFVihpIFJYqZIaTAe63peQ+N4LIrKzQDXDW4pfVwXPY
         b1Bg==
X-Forwarded-Encrypted: i=1; AJvYcCUVELwzzxWtRv0RU2l7Nl5O+4AWj8oNaqZylab2CtePE9HEItJczzVgtl8AphYl6JqjrdY0DpaKsTr2gjU23qhhM4jSffa3
X-Gm-Message-State: AOJu0YxehsbqoFrS2X3kKIQ7sFd/0p6IqAu5eOP/SMpYg1NItN7akiUP
	qR8cteNz0I7JU0YTMPx+av+FhFxUbvzFiWF5ia90wd96PFciR4MSWcKcp3+rbSfXVP25bkBQvAj
	8eSh4IZ+v8zesUu9EWUerUFPlTIM4S2//adus
X-Google-Smtp-Source: AGHT+IFxKYsOrG4ilAXTKiWlIY9sugsT5cdso9SZyJ4+TO3rkpTxQeSesfajzSgpUnqosNMbojqCvWGpQGpS+lQXelM=
X-Received: by 2002:a25:c341:0:b0:e06:fe1a:ffd8 with SMTP id
 3f1490d57ef6-e0bde3ee72cmr18086030276.31.1723044562667; Wed, 07 Aug 2024
 08:29:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240807-macos-build-support-v1-0-4cd1ded85694@samsung.com> <20240807-macos-build-support-v1-6-4cd1ded85694@samsung.com>
In-Reply-To: <20240807-macos-build-support-v1-6-4cd1ded85694@samsung.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 7 Aug 2024 11:29:11 -0400
Message-ID: <CAHC9VhS=KGRCbk-zy4aMiNfi2aMRX6YBP8H3VNAw7pY85TxDRA@mail.gmail.com>
Subject: Re: [PATCH 06/12] selinux/genheaders: include bitsperlong and
 posix_types headers
To: da.gomez@samsung.com
Cc: Masahiro Yamada <masahiroy@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Lucas De Marchi <lucas.demarchi@intel.com>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, 
	William Hubbs <w.d.hubbs@gmail.com>, Chris Brannon <chris@the-brannons.com>, 
	Kirk Reiser <kirk@reisers.ca>, Samuel Thibault <samuel.thibault@ens-lyon.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, intel-xe@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, speakup@linux-speakup.org, 
	selinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-serial@vger.kernel.org, llvm@lists.linux.dev, 
	Finn Behrens <me@kloenk.dev>, "Daniel Gomez (Samsung)" <d+samsung@kruces.com>, gost.dev@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 7:10=E2=80=AFPM Daniel Gomez via B4 Relay
<devnull+da.gomez.samsung.com@kernel.org> wrote:
>
> From: Daniel Gomez <da.gomez@samsung.com>
>
> The genheaders requires the bitsperlong.h and posix_types.h headers.
> To ensure these headers are found during compilation on macOS hosts,
> add usr/include to HOST_EXTRACFLAGS in the genheaders Makefile. This
> adjustment allows the compiler to locate all necessary headers when they
> are not available by default on macOS.
>
> Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
> ---
>  scripts/selinux/genheaders/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

This patch, and 7/12, look fine to me.  I can pull them into the
SELinux tree now, or would you prefer them to go via a different tree?

--=20
paul-moore.com
