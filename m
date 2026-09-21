Received: from mta1.migadu.com (out-30.mta1.migadu.com [95.215.58.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DBD3B0580
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 07:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789974669; cv=none; b=Y+YtQhbBr3BE4CcERL0s79qFhcSGLxO13nMN5800LTfYK65B6ctitFkqXhK0fIMpS6FGhDTzamd9OTAbwlfCuEpuoyAS5AokFmjDFIho2cLI5KiO/qB+ftShgnNOj61oT9dtWr97EDQs+qMgFtEKjSrJNmPPzlRBhuK8uRRHYRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789974669; c=relaxed/simple;
	bh=Eux8pfzDoKUAWcecKGVOzPBlEfy59s1p123uGcIZ0h4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P48V35QOKo6+AkCKkFqsqMP9QSp7eJ16jigJtvHQiIE/j3NzrZJfidxm6JMx58+YHxcXhdbbKAROPbqYsiRtCeRpJgunSUnqSxMIhLiqvq4ZZsiZrmYgWxyenigWHhpwU6FKhvEZmbDho/lw2RhzASWOWbrGeRkniqzugZwIBt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mpjVgvZy; arc=none smtp.client-ip=95.215.58.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mpjVgvZy"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Eux8pfzDoKUAWcecKGVOzPBlEfy59s1p123uGcIZ0h4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789974665; v=1; x=1790579465;
 b=mpjVgvZyYPKeHYwpkc5cJ+tZNni9X5qGLkt+Ucy8/Tawx5JKLYb8qk0txR4dMOktOFdhHGpC
 aDuC8eXF1yI/Fz7uUUgn1048Hk68/mRt9ZaABquEJzT5Doiu4rqedRRYcbYvcGR7IdNQE4oxBG/
 rLpslCxxQueQWmT/N83jwKfk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9c4b74027f7a1e0f;
	Mon, 21 Sep 2026 07:11:05 +0000
X-Mizu-Trace-ID: 9c4b74027f7a1e0f
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b778bdb5b8so5904e87.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 00:11:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzI36msFxzzGWK+LACyCCzDtEn8xs2ZjS1eCsZBiSk6CG/V0gs8d/eqfi4IiiyuzMDgEzBQ1/4=@lists.linux.dev
X-Gm-Message-State: AFuF++mxw5qSawtu9CnJk/kvulz6WMcdVadcJdKFZi9Qr8n6fL88IlZU
	YvjbxvgdXiBosY1u7J8+9/3tFlMwQ+fprGerENlEgnhr5jKKSxL3Vd4GtFbDjYrgewYpAFAzHcr
	YBRHQJq26O7/Q1FR4pVjE3DuUBnZBTO400LmZ3uYu
X-Received: by 2002:a05:6512:2216:b0:5b8:d049:c45f with SMTP id
 2adb3069b0e04-5b8d049c61amr15291e87.14.1789974660051; Mon, 21 Sep 2026
 00:11:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260902134118.2718200-1-fuad.tabba@linux.dev>
In-Reply-To: <20260902134118.2718200-1-fuad.tabba@linux.dev>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 21 Sep 2026 08:10:23 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyHJjN28zXYJUF9otZvyWP5-3Ln0fy=xJ_EE-bOdvMmHQ@mail.gmail.com>
X-Gm-Features: AcwNN1Xk01oNkxJ7UZIT8ZwQcfv1F3nhRMlj7kGCMC3JqdaEoVZDyc6bymlUU9I
Message-ID: <CA+EHjTyHJjN28zXYJUF9otZvyWP5-3Ln0fy=xJ_EE-bOdvMmHQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Fix arm64 sysreg header dependencies
To: Oliver Upton <oupton@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Wed, 2 Sep 2026 14:41:18 +0100, Fuad Tabba <fuad.tabba@linux.dev> wrote:
> The rule generating the arm64 sysreg header targets the generated
> directory, and its only prerequisites are tools/arch/arm64/tools/*,
> which is the inner Makefile. An existing directory looks up to date,
> so an incremental build never regenerates sysreg-defs.h. A selftest
> referencing a register added to the table since then fails with
> undeclared SYS_* identifiers. Clean builds are unaffected.

[...]

Gentle ping on this one. It's arm64-only (the Makefile.kvm rule that
generates sysreg-defs.h), so I think it'd go through kvmarm rather
than Paolo's tree. Could you take a look when you get a chance?

Cheers,
/fuad
