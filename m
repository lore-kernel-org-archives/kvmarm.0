Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3429FB669
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 00:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726014111; cv=none; b=TGagNZPUc2KW5PMTbvwxbo+RqCtZMrhZjw7eYhUYIZi4MblWpPKkRfeKbYbsmmXRJOrHtaS6PaYJ5Sp692TEaFaNlW0KKNiKHiD1mGWhVU+SrZHzpaNi0NYtd14V0JTbjStM3PnFQ0YqR6NimK6dyVZVQPLeSWU3VEIX8bsfHaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726014111; c=relaxed/simple;
	bh=XJsAOMeR1xyoAviG9h+i3BRNuKdHXmsziYQPTgOLA0g=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=QN0pUYCSulEh+cDCc2cU1K7AqpT1sZi5h5FLA8rhQIQsygBJxuwlF+tnoo3ALpmVvipwD8WxvL0d/pEnp6Hj98TmSht63zydneYieGHBuDRNUE2fVqab35kdgr+5hWZnYv7h6dbkU852DIvm62506o3jotWjhXEG8MhCtYBb9+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XeHXwPcb; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XeHXwPcb"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2059204f448so51542225ad.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Sep 2024 17:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726014108; x=1726618908; darn=lists.linux.dev;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JeW4Y0h7gL1bTrw9BgVO7v31cFSL53BgLr+Fcn1Qzkw=;
        b=XeHXwPcbMWJhxGtPYaHjJr01i0vsPZYVwL/0I3KpZ2DBPCO+loG5jXi/ByxrodJu8p
         DBUxMN74Om6EBPD5h7usVK+4UiYHVa0XvaYLBoJP7Ejs6eUxGdV51lliw6MSwDYdRSQa
         fhfZypLJvSxXUwNdfZZ7l0mrx+GiuUFv7I7mV/SpcizkYM6dvbQkMRiJrAj3rATmBuAW
         xbQIpo0pZUBy7by4nUrCorjSyRsgsMs0uo3aVOzh4JyXP5Zxg1Y1ZZ/zXaCqwtYkUhrR
         RbL2/Ll6NhTX1Grr8pjr5SNPSlh5YZtqliilMG5wVcvnKi/LqLK0jc1ef4lxG46x1WC+
         tNYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726014108; x=1726618908;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JeW4Y0h7gL1bTrw9BgVO7v31cFSL53BgLr+Fcn1Qzkw=;
        b=kjGhNzkDpwtgJU/pYZe3MfnwnahV+DDF5oExkR+XBV6P1C/DG893PuDcdCtG5h4Gge
         7ni7BoIpN6T/YaTjlT4GP34P781xt9eUzyZ16L1vvpaDkV+bqp/kwV+GmTxkFaCALX1n
         83k/aVzGmRqlNnlmA0WKq4GRs1S40+B73nCntzPWdNvrPOF1lL5iAX2/rheetdf0HCup
         OJUwplao5Zd8rQkF7Msgh6RiOtoQ7lQBCAQlmQirx44n4ArO9ghhNAcoZ0G8LND7h99r
         VRCSe1fFOkB5hAKs90JPf39SsX/uGvqODNHitvX+PlyHYS7iTbVGIV9RbWSyYvyDnA0Q
         9evw==
X-Forwarded-Encrypted: i=1; AJvYcCUCC68qcEcACIArCJvS79t7gRY3aTy6RWm3c1japTweXJVlvff5fEdKec17YEViNgDiXF6oQa0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxr1mjaaIGQ061UK6RWqjIZoLrf5oC4LLgy9eg3vlPaGg2ESq0+
	LZoPiUW2F2zQIH3pUSfyiJwbSuQkKh7RP4S0Eu09x6vOxcN5lKEp
X-Google-Smtp-Source: AGHT+IGpFgBeviIk7STqAhQZktkyXQGuxb0SJW7P1uto6lzV5ThtJVUyImgUcmDFmHHJeJktFhH2hA==
X-Received: by 2002:a17:903:2447:b0:206:c75a:29d4 with SMTP id d9443c01a7336-2074c6ed1dfmr36845375ad.50.1726014108401;
        Tue, 10 Sep 2024 17:21:48 -0700 (PDT)
Received: from localhost ([1.146.47.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710e3365asm53646465ad.97.2024.09.10.17.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 17:21:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Sep 2024 10:21:39 +1000
Message-Id: <D430XMRU4FZD.1FFPMW6WVWRSD@gmail.com>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>,
 <kvm-riscv@lists.infradead.org>, <kvmarm@lists.linux.dev>,
 <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>
Cc: <pbonzini@redhat.com>, <thuth@redhat.com>, <lvivier@redhat.com>,
 <frankja@linux.ibm.com>, <imbrenda@linux.ibm.com>, <nrb@linux.ibm.com>,
 <atishp@rivosinc.com>, <cade.richard@berkeley.edu>, <jamestiotio@gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/4] Makefile: Prepare for clang EFI
 builds
X-Mailer: aerc 0.18.2
References: <20240904105020.1179006-6-andrew.jones@linux.dev>
 <20240904105020.1179006-8-andrew.jones@linux.dev>
In-Reply-To: <20240904105020.1179006-8-andrew.jones@linux.dev>

On Wed Sep 4, 2024 at 8:50 PM AEST, Andrew Jones wrote:
> clang complains about GNU extensions such as variable sized types not
> being at the end of structs unless -Wno-gnu is used. We may
> eventually want -Wno-gnu, but for now let's just handle the warnings
> as they come. Add -Wno-gnu-variable-sized-type-not-at-end to avoid
> the warning issued for the initrd_dev_path struct.

You could also make a variant of struct efi_vendor_dev_path with no
vendordata just for initrd_dev_path?

It's taken from Linux or some efi upstream though so maybe it's annoying
to make such changes here. Okay in that case since it's limited to EFI.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>


>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  Makefile | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index 3d51cb726120..7471f7285b78 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -50,6 +50,8 @@ EFI_CFLAGS +=3D -fshort-wchar
>  # EFI applications use PIC as they are loaded to dynamic addresses, not =
a fixed
>  # starting address
>  EFI_CFLAGS +=3D -fPIC
> +# Avoid error with the initrd_dev_path struct
> +EFI_CFLAGS +=3D -Wno-gnu-variable-sized-type-not-at-end
>  # Create shared library
>  EFI_LDFLAGS :=3D -Bsymbolic -shared -nostdlib
>  endif

