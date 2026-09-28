Received: from mta1.migadu.com (out-191.mta1.migadu.com [95.215.58.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE27B35C1BC
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 09:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790587776; cv=none; b=hvrF7WmAyrPf6YG+qWUeeJECl+3lxSniodnqL4mFXpl9pFmEE75qkfcClkh2jng+O7canvUcSGt54TbW42u87LiZTNUxCn7icgT3+FtkkmeuHmfIUK5uwXh6MfKuocHaWKW3NUs6eGYUX/iLssfth02ioPDKemZXht5rXr+ctL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790587776; c=relaxed/simple;
	bh=mNyW1L2Kl7XsWs4BhSwMHQIYW+aVztuR3efDX2CQxJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dREB9EfystHvKgsGJE4KTegxdtnkze9g3osUquCi/eOLT3iQf7LW0LN5IfLX9SxUePxRtlopS30S7HiJH3YzX2b4bIjCYUBBFtjCQoQZThl12pb530/UQX9vpyxNjIz7mf1OSLA2bPkVF+uXjU7wP277FEqkrOeXdiLbyjuAhtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kurcTqjw; arc=none smtp.client-ip=95.215.58.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kurcTqjw"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=mNyW1L2Kl7XsWs4BhSwMHQIYW+aVztuR3efDX2CQxJ8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790587772; v=1; x=1791192572;
 b=kurcTqjwX2ebHI06+vUBDs5nR6tN7BH7aNipDyaCscPxBJjwGkCmd5OKNgEa5IT1UXBD9nu+
 teJGc5t8e4/AkjIRitAowmu4YFZjoVAnj75z5z7A8XE6GSx17vBsV/BfeimDCsZcqbR4Ib7bl0a
 G75KA1cm92A+c8xQmJrzgK0g=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 8a9b806800588ff0;
	Mon, 28 Sep 2026 09:29:32 +0000
X-Mizu-Trace-ID: 8a9b806800588ff0
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b8f42bb8a9so4988e87.1
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 02:29:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByWf0sRZsV/kUSunsGcztmc5r7/4CGLNlucATmREjYeE7AmQj2sceiQJQ3xfRVnqwz2EcgsM3w=@lists.linux.dev
X-Gm-Message-State: AFq9FYJBCKHYNmzBErskRLk9d3BvUByFhCxDFKxYyJCvUmEY+FNDDC+Q
	8CWrRpTOPDBEji7QNeMpRBzeQqYikYTIl9ytt6+VGpo5SyNPb6huLgj3OawWL141UzYzDYTtlCz
	LEA11mJ8m8YqDRJfOErwHNSaGBz9x1vtPkyL1VFqy
X-Received: by 2002:a05:6512:3d8e:b0:5b8:c8f2:16c4 with SMTP id
 2adb3069b0e04-5b8ef255fa0mr175606e87.10.1790587770867; Mon, 28 Sep 2026
 02:29:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260928064643.3265087-1-fuad.tabba@linux.dev>
 <20260928064643.3265087-5-fuad.tabba@linux.dev> <4095827e-dbbb-4ab9-8610-1bc317aa096f@oss.qualcomm.com>
In-Reply-To: <4095827e-dbbb-4ab9-8610-1bc317aa096f@oss.qualcomm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 28 Sep 2026 10:28:54 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxwffM9vQ0c8MQgsojsXOAUOzo8qD1=aoRK_zGvBF0XgA@mail.gmail.com>
X-Gm-Features: AclHuK9Tx9jSnIhG13zjawNFq0tNHoDD4fS1QJa_ek8GgO61EjctlFamlrJQUSM
Message-ID: <CA+EHjTxwffM9vQ0c8MQgsojsXOAUOzo8qD1=aoRK_zGvBF0XgA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: selftests: Check a feature hidden in
 an ID register is UNDEF
To: Venkata Rao Kakani <venkata.kakani@oss.qualcomm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Venkata,

On Mon, 28 Sep 2026 at 10:20, Venkata Rao Kakani
<venkata.kakani@oss.qualcomm.com> wrote:
> > +     for (;;) {
> > +             vcpu_run(vcpu);
> > +             switch (get_ucall(vcpu, &uc)) {
> > +             case UCALL_SYNC:
> > +                     got = uc.args[1];
> > +                     break;
> > +             case UCALL_ABORT:
> > +                     REPORT_GUEST_ASSERT(uc);
> > +                     break;
> > +             case UCALL_DONE:
> > +                     kvm_vm_free(vm);
> > +                     return got;
> > +             default:
> > +                     TEST_FAIL("Unknown ucall %lu", uc.cmd);
> > +             }
> > +     }
>      Return missing?

No, the loop never falls through: the breaks only leave the switch,
UCALL_DONE is the one way out and returns there, and the ABORT and
default cases end the test. So control can't reach the end of the
function.

Thanks for having a look,
/fuad
