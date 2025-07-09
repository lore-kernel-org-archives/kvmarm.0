Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F00121B9F1
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 22:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099951; cv=none; b=MetdynT/tPmn3Dg4LLD3RvispZNe06+Qxy7HRAep6xowOQtv0G2E+zaeh4bQjdxytmt/MAJJeAsTFO6eBsksgknyiDBouQehNotMa1M1XIXlVrtoGlP3Da1CrSPX42awnK0VrzOxHdnGpxsmodkx6d3kencLdNKxTpmUg11M8hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099951; c=relaxed/simple;
	bh=dkJ1PtZQqXxYBvMHRQpoXnzlUKAa7PWDoMi8PXhc7QU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kbSYrGYUbF9LNQ0Q9ubVGgUfOD+0fms//DcMxoAJ6AMg1LJpVy0IyCr84wREsni0F7Hu72tiOu09wvBHkm/wv8otPJbAFXn4nLPzHmyvZ1bADWM+kuKbIUho6MrfWnBZFGS7cH4IBHqygjrWfyjw9sqQp8Lp82jLoK7WBywYXrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kg9f2xWX; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kg9f2xWX"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74d15d90cdbso242543b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 15:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752099949; x=1752704749; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CEkPKw3M8obzlysqjDzuJ0l8ChAy9EN0Uu/m/zS8TW4=;
        b=kg9f2xWXKSEhYTQFqllxascmEvZ9Uc0RUyGr1cx3yHxdiV//H5oJDaBKuWA3CYYxGh
         6eV9cv2Tpwr5vaPgyhrDqfTPk6ZQVI/vAMAnQL56ZxCXHVC0LJ+rC0qDXxLcSCWtUfLO
         aQ1vPsMKoCNIK4BGlwTcqxhECxO++v/aDyw/GV2xRyN+4zGymUC4g+p8FbnEjaNKhizQ
         TTZ9M0d0FXxKuK/57B6xDzC9IhGvG60G4qdnk7/ijLMZsUbSCYK/tLnQYrlVzJ8VATlC
         f5HF5LKyMFlkqDKJ1519QJhZaHtaUKzToqiRX36+E238DZiWtQHZJRpxWaICiS8a10TV
         VCpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752099949; x=1752704749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CEkPKw3M8obzlysqjDzuJ0l8ChAy9EN0Uu/m/zS8TW4=;
        b=dxUI20Vqoi8jUyuh7KATN755OgjGkDQRuUrHPDYgyGrSuhBIEWvuFdyxEAs48qv0q9
         jTbxK8wDcIyEdNpIUdws4pHiFxxtT/XaOgR/oipq8x4fI/GpIiyAf/qV1E2ukzpY1Ngn
         jembCmXnbWVZnopePiRDJ5K2Y1fYRzbnvDJcYw5xCjFjJcErKkJIkIZz1uer+Nvi5UDb
         BnwS7dXkpec5ymXYb1750jknI+eZI8YVzjQjM9foyg9M2pHgc+lk0CDPz/27d8HU8tTE
         HKJ0pef1TCpTG68OL00SdZNGmq3Z0RNVGqVwO6wvX93SMiEUJt7+6ilHyhhJFCDuNHsk
         XeOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGiBpzJ8N2m1buQsYj57XuhrtzR6plxxvzGCoyJppMKefircs3jxlUp3HyZxchUbPpPMlO/Lk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyYBeyrhRQWDXWnRZ0RFbec9UGNvrgOyDUwzFOyvU19CBIzLlsL
	cVSWvyi98/Q2ZzSiw88nX3yo3aPo8yBRkm0QF3Huv15igT4FgbvVaNgHCDDmkqHVFBjUEhm7sHi
	Dbax0cA==
X-Google-Smtp-Source: AGHT+IHzaFg8XpZkeBot1MQe7M9Yb3LfWilFjWjxq3XfLXBIK/XNa5kNoc+2CdqHT487bCXwnmwMfiMG/dk=
X-Received: from pgjr1.prod.google.com ([2002:a63:ec41:0:b0:b31:e758:d80])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:502:b0:1f5:6e00:14db
 with SMTP id adf61e73a8af0-230040e3516mr508970637.14.1752099949457; Wed, 09
 Jul 2025 15:25:49 -0700 (PDT)
Date: Wed, 9 Jul 2025 15:25:47 -0700
In-Reply-To: <20250606235619.1841595-4-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com> <20250606235619.1841595-4-vipinsh@google.com>
Message-ID: <aG7sa2fju7noUS8L@google.com>
Subject: Re: [PATCH v2 03/15] KVM: selftests: Add timeout option in selftests runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev, 
	dmatlack@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Vipin Sharma wrote:
> @@ -48,10 +50,13 @@ class Selftest:
>              self.stderr = "File doesn't exists."
>              return
>  
> -        ret, self.stdout, self.stderr = self.command.run()
> -        if ret == 0:
> -            self.status = SelftestStatus.PASSED
> -        elif ret == 4:
> -            self.status = SelftestStatus.SKIPPED
> -        else:
> -            self.status = SelftestStatus.FAILED
> +        try:
> +            ret, self.stdout, self.stderr = self.command.run()
> +            if ret == 0:
> +                self.status = SelftestStatus.PASSED
> +            elif ret == 4:
> +                self.status = SelftestStatus.SKIPPED
> +            else:
> +                self.status = SelftestStatus.FAILED
> +        except subprocess.TimeoutExpired as e:
> +            self.status = SelftestStatus.TIMED_OUT

This needs to grab stderr and stdout from "e", otherwise there's never any output
to the console for timeouts.
