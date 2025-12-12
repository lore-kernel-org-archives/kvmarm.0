Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA10A28DB46
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 02:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765505503; cv=pass; b=JCmglrA/neUQ0QSBiq/8Onsa51SuSH3jTKRTHBVz+uetJG0YuuLd9Uak5b0Iikauh23e0+nQTwTriZUk3lbM3jcESFt2gI57aLIJ5I8s6G+A1xuQivlP2ZrPNcsF1QILH3uxwyOWhUAsRf0+742Q3YWwJISiPbXzZNX2bDhaLgc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765505503; c=relaxed/simple;
	bh=Ao4814nx/MeyiCjtOPdPxV2RF0Pfv1gFdV6IO+0/tn8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O5XrIY8lq0RXkn1VYQCJDaJH4IpgQ2YbbL1yjAwqyLG2kSqD/cDylf+LabNMLfGuDZuG49AgHvWqvhOisEX7PW8hCuSru+U51qxhMVg+IA1bjtbFZgjMOPOs+/DZ+6+UXa/eLoV55FmPgTCHFeLI4DtcfmDPXmiP/X84Zjg3qo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QGzjqOHx; arc=pass smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QGzjqOHx"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4779e2ac121so121755e9.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 18:11:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765505500; cv=none;
        d=google.com; s=arc-20240605;
        b=IDzKcBbbNq0/tYJ+j/a+hxkgO1hgDKl6YU6p5578r8dUWT6sseiqC3FXFQE/rmn5Md
         u+JrRDGYLBQC83w1OK/qFvXYLtumleF9A6r+xVYxf/uvnHb/oqq8PGg9/DsSRJd4JHXH
         DzN4S8CDNlQ/MSs22AbMOhEHiV+3dT6gCOEuftJPuxiVmKPsutvQAmsMdNqB9qwaBlL0
         YWl2VMencaV4ZOvJhwErW7k9uo3GDqx+HXk71tAr4I9HUI9jCob22v4Z61Irrc1iGpxw
         0ao6GhCtPDZvotE5zQmBNJM0IGjEeAk7whPZVkhlZR5RKVgtu1GRLERhI1wE8cbeAqBm
         HDcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KKXbQJ7VyOdfJwU2Y+H1IueDoIplm0PygWT6mOen4rY=;
        fh=BS4u/gXsygt1F7Xf4IqkkIxPyUtxynUv4og45lkn3io=;
        b=G8HsKCvF0op+EZWsxcUDydu3Yrny9OVMCLzqD5qJV/UhWCLj7UFAVh4Gz+V6NCei8a
         qaWlA3PpJ4v9/TiX8MMnq1gZztGp51CDsD4mEd/CbohX4PA7iVvyC2e3pmIX5QNifwPf
         HrZg3GRAb6Gfx4dWbOvXIm0sErb44w7vmRGVJN9GHeWYBbP7nUbFKhAOO5nDeODv039A
         giG8Q8xIlaccDh/Z9c9P6A9SYFRGo5R8VCKZ8Xjhpi5RtE/t7UJytgq4dZSRCqPJTkFy
         RVXel58T62CS97fAf/Nl+7Zfg9p5OuHmR8NP6i34rR0rKn71ph9JzHSKnFqAoc/X+RA7
         9+MA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765505500; x=1766110300; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KKXbQJ7VyOdfJwU2Y+H1IueDoIplm0PygWT6mOen4rY=;
        b=QGzjqOHxkym5BLFgSOlSiBRmWFmDpTDDArgnPrz0Dx/feY03WkQKGRnwDpkbGYkmgY
         oTOup4PQ54V1WwZzGNEUBYmgm6krmm8QboZBhcCU159dmLnvfLun/nYO/0i1qz2rxdJI
         aEE0ZEcYkxv+Ab0bRLvk2LnXLPxbTWGtUBzimhB1lTrSHkV/QQXpuDIKcoY4oF943ss3
         mjbqB6P4xk+O6PZ6dKWFzgkqcv0OSm2cQ132oyoSvQzx+A1pU+gn52DDAVJdQ7Pc8KuG
         0dfcfWOciOEI4TTMBpZBulowKAisueYswLe9on9LL5m7uhn/LUXsl0SZ7kA/kFMHGFsI
         9mgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765505500; x=1766110300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KKXbQJ7VyOdfJwU2Y+H1IueDoIplm0PygWT6mOen4rY=;
        b=V7NbIF8nZfwS2w+e3aKTI2MhlYrgpi62+nPw01++ueoWI+kJMWKKV7KxcP99P9bvAg
         D5HiF5czpnn/I0XZSyGLmTPE4CPmbynn+OxfwP15cezKJ7QRqwhOTlLG7osXXb2QwOhw
         zmn6zcOgSGFOk8OAx+24A39mq+ZEzZEXsgFPzsqIgvyA6wvjGyQUjQiABj7YaGMsqDzW
         tior60CDsyzEqG0zJLHWDMnEF6NY34cz/Myt0cn3/Im6PrY3MfvcmJzxK9lDnvnlTpnw
         4vHirN/TTnTXyM7YuTzTBKH6vBjmvz0CXi8/aI8lPAncRI3U0e0aCEPeiRwDnZHfngq5
         uXVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWMQbtN8tW9H3tfOoop1mJ5F8HFWvbZlJcANSI71b/+0dDtcv+lE5bV1invMIMzgoVLNxqVwI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYAffNjJo+RYOguuCIm6BYoca7vR6gwbxqpvU5IiPpGfUvWBny
	zU4OkZ9SGJKAeajsDTAAfA9qsflK+4rczAgjTYm1gMcQhr+48cGSb9EHuKhNtyE5upXgmEOoSbk
	6bbx+JxT+6SQfRNUNpov0qoFr/yEKx5QGlyuVplea
X-Gm-Gg: AY/fxX4Si5F1R1XXXYLxtf5lAZ5pViyXr4fXulBS2c8pDqpPF0Jm6pkKy/NS47sxbip
	Werkkq+zFFvJfFP8aLyKbfzbL8XOd+oFbKQylVRIX6AbR3A/0of6ZDbjCkxIhs7cu5WLd8Dmzs1
	xHKJsnCWl+A3p4wLdnBcEwt3HUJ0MHq6ZJsuZ2JbYCuZZSItccsgQ8nAt4vtoIW1Wz+9DP3LU7O
	IUIxtETlBnv+bg2KAsVQBEcrwrGOobSekWusNnz1skD1oUNHvmXeThEiFU8iNwHNL+JjGYMEZ4A
	tB6UVNO8WPNEqFxNGgMt6ZG69eFQ
X-Google-Smtp-Source: AGHT+IFYskZ/bgUJL8oh+IWDpPaPCx1TyYrhdztCLLCAnfYuBrsXrdmOgn4LN5g44F9X73hGi18eDted1V3Fai8KP/w=
X-Received: by 2002:a05:600c:c04d:b0:477:95a8:2563 with SMTP id
 5b1f17b1804b1-47a88c67cb0mr445965e9.14.1765505500063; Thu, 11 Dec 2025
 18:11:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1478ac09-8134-5551-13b6-c7be096262af@redhat.com>
 <CACw3F52i_Yr+8Gd1=H=EMi7NnVJ8WCgMkaG1dSe8FD7PvOsW8w@mail.gmail.com> <86sedgop86.wl-maz@kernel.org>
In-Reply-To: <86sedgop86.wl-maz@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 11 Dec 2025 18:11:28 -0800
X-Gm-Features: AQt7F2ruwRGIX7zw26TKkYRQ458cNr4PLpCMeJupnhA1pZONZUfBkBxbqR-PLiM
Message-ID: <CACw3F51usGLY+ZAqy3WEW+cBxCQysHDuM3ebvC-Adkwf_+zP8Q@mail.gmail.com>
Subject: Re: sea_to_user sefltest failure
To: Marc Zyngier <maz@kernel.org>
Cc: Sebastian Ott <sebott@redhat.com>, Oliver Upton <oupton@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	Zenghui Yu <zenghui.yu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2025 at 10:19=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Thu, 11 Dec 2025 18:04:48 +0000,
> Jiaqi Yan <jiaqiyan@google.com> wrote:
> >
> > [1  <text/plain; UTF-8 (quoted-printable)>]
> > Hi Sebastian,
> >
> > CONFIGs seem alright to me. Do you boot kernel with cmdline options lik=
e
> > "default_hugepagesz=3D1G hugepagesz=3D1G hugepages=3D64", or dynamicall=
y set up
> > huge pages via "echo 64 >
> > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages"?
>
> I don't think this is irrelevant. The whole thing seems to have some
> logic flaws, see the extensive report from Zenghui[1] as a reply to
> your series.

Perhaps my test is too coupled with my test environment. I will work
with Zhenghui to improve the test for people.

>
>         M.
>
> [1] https://lore.kernel.org/r/3061f5f8-cef0-b7b1-c4de-f2ceea29af9a@huawei=
.com
>
> --
> Without deviation from the norm, progress is not possible.
