Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E14029DB6E
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 15:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749742196; cv=none; b=QH7zujzhiZisaJSnEi4XEELWKYZwwsC0xMyatiSJP5kWRA1Ei+rDg0vus13UxXGXqQR2d2ad0vWdc5S/WyhyVxqimo3gdKSORMH9QdgWt2IOY/dnRvIEmQh49Ihjv766CSc0ZMtXPAbjs4NgyJToWCoL5Ybx5NOw6Jp+IQ19Oto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749742196; c=relaxed/simple;
	bh=t1IqK6p7nBIDP6T9YM9E3mMQ9+httXSZAipBfvbCnaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cPa4PzA4M1UGIyeyL8POFoHDLoCrTyZDpn6vistw06j7L6GV5hI72FXcIJLnaXeEKNkZS4H7onoRHgAXoiFAWQ0xIQ28atwmnzalzaf2XieQuLyg+6/2qjxG8/PAzQqLSuRgdm/bz3EqT2/K9Yl44YYiJywT8TvMgihDvmT+w4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PWb+1w0F; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PWb+1w0F"
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e740a09eb00so918343276.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 08:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749742193; x=1750346993; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=geYJAPYMrYCt/FNmyMs6RoHZ9I62sqBam9PO+m4TAek=;
        b=PWb+1w0FQv8zSZh9kKxSZG11pb8DY43lup8YJBwKf4vG89A1jVQ04KBHzwc8of+WzM
         xn0MBaWxnZUopyZJa5YwGw+e4I+JwWdTkWV0rbBncmfHUyC8QZdyYqe0MM4owlKpZ9Pr
         QpHJ2q8fM+ukhb5MADswLuheIbnsZky4irNymsvE14kwXLoI0AkbWzh1SIvN6bcOdY43
         8BgFsTkjjqmBvflRFvDZaapw7KgfTPFikKMCs+uyGyeRsF1LKCRnxqYvOixGjnfeUuiK
         9eSVG6lPczmaD8scAfebWmV7zZl/vsYL/LnV+BCx5KVA/N60fANvvnA+qdgeRb34tDaV
         OoQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749742193; x=1750346993;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=geYJAPYMrYCt/FNmyMs6RoHZ9I62sqBam9PO+m4TAek=;
        b=lQPC9svzIEKisQ4HFkQ63/dHTv8ctgvl7f/xBhMLpVIF70vGAyzGuiPc8a4ni8/NaV
         0ZghaZHMf0YJBLA/E8+nud6odeJK3QYMaW6btEX5SHhFgF9PXakGnaROHG8+3In2V5Wu
         2/esFrYqhcM5js99Cyti3ZvRj86Ty+Ija1tuy58uf9uOQHr+xcNvhG8RJ20YdnY9HFYU
         F7enJFJVhpvTUpkrlnUYQi8AiaRmoFFB7IUg+vrVaTx0xn+SiCrfhK9Nb4iIiMTkvxwG
         mySO/LfdcRKBxS7tFF+P3e8N/9RoRLON0RPml9SwBtOjLFchfjBO3wDGXbDIjAQ+efmO
         uzmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpsiNYBF5mpL/UNdj5/OtAIuL6ooUoOAmzQ4/5kaG+lecX/vz/VxC/TK3ch68E+fRH34lwcXk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwEXboVKviPEq2X6Oo3OtU1UYpBFtNPy6eZAiyltZfwtWKMS1cW
	dTqVsbC6QTG81ps1tvidJ34gYSjy1vrrSn0p5N57AKyaqCRuP43HUILQgdRdW2T6QGy4SFKAICg
	JmeQg5aFbrL65Mtprlh/SSi+afzY/fnngcb10/9U/cg==
X-Gm-Gg: ASbGncvW5CKwG801DagaXpvTVbUPLwtSSQEJgiFqXrv6EgZbfDy6HDq9bgy77Tbr6J/
	H9FgV+SrN87zgwscfkb/U/9gzFjEHRNGY5A8Cnlvnk2cmXkiMQiigmpmRV6kjLE3YO1dLW0gszp
	zuoTzuTA9ZOHnhbC8r/aB8DLyWC+G+mOwTe+eUgT/rZ0kw
X-Google-Smtp-Source: AGHT+IENjmqyi7346POaDkGZR6RfoGXIVitfUyfSfUlXG98lTBAK4TulNP1eC5vKMUT/0qOqM92Y6Hx33E5GW3olJ4A=
X-Received: by 2002:a05:690c:7483:b0:70e:73ae:766c with SMTP id
 00721157ae682-71161effb98mr5173077b3.22.1749742193383; Thu, 12 Jun 2025
 08:29:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250515153907.151174-1-cohuck@redhat.com> <20250515153907.151174-13-cohuck@redhat.com>
In-Reply-To: <20250515153907.151174-13-cohuck@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 12 Jun 2025 16:29:41 +0100
X-Gm-Features: AX0GCFu9aivLSnaUx6RMU2aaTzhZKVbQDpI7U6eisLoQVjKLj6ZZzS6PLa-nZE4
Message-ID: <CAFEAcA-xDxoRLWZCMrAEeSb3NvyyOPzYgFQbbEzGALujOOG-3g@mail.gmail.com>
Subject: Re: [PATCH v7 12/14] arm/cpu: Add sysreg generation scripts
To: Cornelia Huck <cohuck@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org, 
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org, 
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev, 
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, 
	berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com, 
	agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 May 2025 at 16:40, Cornelia Huck <cohuck@redhat.com> wrote:
>
> From: Eric Auger <eric.auger@redhat.com>
>
> Introduce scripts that automate the generation of system register
> definitions from a given linux source tree arch/arm64/tools/sysreg.
>
> Invocation of
> ./update-aarch64-sysreg-code.sh $PATH_TO_LINUX_SOURCE_TREE
> in scripts directory generates target/arm/cpu-sysregs.h.inc
> containing defines for all system registers.
>
> [CH: update to handle current kernel sysregs structure, and to emit
>      the re-worked register structures; cpu properties will be added
>      later]
> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---

> diff --git a/scripts/gen-cpu-sysregs-header.awk b/scripts/gen-cpu-sysregs-header.awk
> new file mode 100755
> index 000000000000..452e51035d52
> --- /dev/null
> +++ b/scripts/gen-cpu-sysregs-header.awk

This should probably have 'arm' in the filename somewhere, unless
it's really architecture-agnostic, which I don't think it is.

> @@ -0,0 +1,35 @@
> +#!/bin/awk -f

Does this really need to be in awk? Our standard scripting
language is python. This isn't run at build time so there's
no "extra dependency" issue, but we currently use awk only
minimally and almost always for trivial stuff.

> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# gen-cpu-sysregs-header.awk: arm64 sysreg header include generator
> +#
> +# Usage: awk -f gen-cpu-sysregs-header.awk $LINUX_PATH/arch/arm64/tools/sysreg
> +
> +BEGIN {
> +    print ""
> +} END {
> +    print ""
> +}
> +
> +# skip blank lines and comment lines
> +/^$/ { next }
> +/^[\t ]*#/ { next }
> +
> +/^Sysreg\t/ || /^Sysreg /{
> +
> +       reg = $2
> +       op0 = $3
> +       op1 = $4
> +       crn = $5
> +       crm = $6
> +       op2 = $7
> +
> +       if (op0 == 3 && (op1>=0 && op1<=3) && crn==0 && (crm>=0 && crm<=7) && (op2>=0 && op2<=7)) {
> +           print "DEF("reg", "op0", "op1", "crn", "crm", "op2")"
> +       }
> +       next
> +}
> +
> +{
> +       /* skip all other lines */
> +       next
> +}

Generated source files should have a comment at the top
noting that they're autogenerated and how to regenerate
them, please.

> diff --git a/scripts/update-aarch64-sysreg-code.sh b/scripts/update-aarch64-sysreg-code.sh
> new file mode 100755
> index 000000000000..e34538887dd8
> --- /dev/null
> +++ b/scripts/update-aarch64-sysreg-code.sh
> @@ -0,0 +1,26 @@
> +#!/bin/sh -e
> +#
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Update target/arm/cpu-sysregs.h
> +# from a linux source tree (arch/arm64/tools/sysreg)
> +#
> +# Copyright Red Hat, Inc. 2024
> +#
> +# Authors:
> +#          Eric Auger <eric.auger@redhat.com>
> +#
> +
> +linux="$1"
> +output="$PWD"

We seem to set this but then not use it.

> +
> +if [ -z "$linux" ] || ! [ -d "$linux" ]; then
> +    cat << EOF
> +usage: update-aarch64-sysreg-code.sh LINUX_PATH
> +
> +LINUX_PATH      Linux kernel directory to obtain the headers from
> +EOF
> +    exit 1
> +fi
> +
> +awk -f gen-cpu-sysregs-header.awk \
> +    $linux/arch/arm64/tools/sysreg > ../target/arm/cpu-sysregs.h.inc

This looks like it is assuming that the user runs the script
from within the scripts/ directory ?

Following the same command line conventions as our existing
scripts/update-linux-headers.sh is probably the least
surprising thing.

thanks
-- PMM
