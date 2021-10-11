Return-Path: <SRS0=aM0J=O7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BABFC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 12:45:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 13E9C60F3A
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 12:45:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 13E9C60F3A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 893EF4B0D0;
	Mon, 11 Oct 2021 08:45:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 58CUgGIuGorM; Mon, 11 Oct 2021 08:45:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AC484B0BD;
	Mon, 11 Oct 2021 08:45:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56C744B0BD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 08:45:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id COJVFx6l5-nt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Oct 2021 08:45:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62ABE4B0B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 08:45:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633956341;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=1OrNVA8Sum/0qGVU4bHkXf3IIyRkEs8OZ6pOfDw9hxg=;
 b=X3W/ARInGP7gck+15kswk45mg9xnLl8n3Swbv4IofUSapMVR59O6ElYlbnLS7MSvsMu2gW
 /O+vNtytSJQnKXmpJyHdk7Wl2zKM6NENkslb/Xp/cMUMaLg5Y02Tnsyr5maAb97X+q+Eok
 8qk0qPeYRSSHB8e2KA6WukXCC+cLtvw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-AxdYtixCNCSfkkJOyv1RzQ-1; Mon, 11 Oct 2021 08:45:37 -0400
X-MC-Unique: AxdYtixCNCSfkkJOyv1RzQ-1
Received: by mail-wr1-f72.google.com with SMTP id
 p12-20020adfc38c000000b00160d6a7e293so10699940wrf.18
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 05:45:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1OrNVA8Sum/0qGVU4bHkXf3IIyRkEs8OZ6pOfDw9hxg=;
 b=Qh5fZjjBBbnopNapQTlFrMHbaJAWXUVfdmo4zpN8awWuM2IyPvx+0QvjIN8DCWdlpp
 KHd3COWLhIlQ9GKG9iiEPVFx21EMJK1ZTrheNQtXs720o2XvYywB/70HKGL8llSIa1Hr
 NUXz+l3IgdFLuJc+b6Qh5MuXZZFdwkRGX9MvAJK7Kday4kcM6hvJfzx3b4bLapNk7+3+
 EBwQGpoChqQv4ui5vemgGK6S5KL3MARUpMgD0EVVWrpEdLzRJTlQZo1mskkKMhGFcglJ
 R6XCejvDJ0uLvcyabyr/7IDWyJjbXI0mQlJMwJhqEBwMC/DW17I64TRwW47co3erK4je
 mBKg==
X-Gm-Message-State: AOAM530T4wypxdMEIVUdQ4LmfjMcpVdN24oQnWQt6vUo2I1glgKWZwGV
 md7zZh98SxiYPV/Hklf5c+mtcYCIuroaTABNHsSThwiizXRo0UL7GDAr3porTdVleGe1aMBtVHD
 4q44z8hfhsII6drzF0YEgIH6U
X-Received: by 2002:a5d:6e07:: with SMTP id h7mr24349548wrz.316.1633956336588; 
 Mon, 11 Oct 2021 05:45:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAKSt+vtlT4L/ib1Qi1M12wj3j0EVKrPrc/Z6SSIBl5V/ZDrG8Mczlry2JWMWkM1jT1sYPUQ==
X-Received: by 2002:a5d:6e07:: with SMTP id h7mr24349529wrz.316.1633956336336; 
 Mon, 11 Oct 2021 05:45:36 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id v191sm7860699wme.36.2021.10.11.05.45.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 11 Oct 2021 05:45:35 -0700 (PDT)
Date: Mon, 11 Oct 2021 14:45:34 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Use get_raz_reg() for userspace reads
 of PMSWINC_EL0
Message-ID: <20211011124534.m7zzpsv3ymp5xxzo@gator>
References: <20211011105840.155815-1-alexandru.elisei@arm.com>
 <20211011105840.155815-3-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20211011105840.155815-3-alexandru.elisei@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Oct 11, 2021 at 11:58:39AM +0100, Alexandru Elisei wrote:
> PMSWINC_EL0 is a write-only register and was initially part of the VCPU
> register state, but was later removed in commit 7a3ba3095a32 ("KVM:
> arm64: Remove PMSWINC_EL0 shadow register"). To prevent regressions, the
> register was kept accessible from userspace as Read-As-Zero (RAZ).
> 
> The read function that is used to handle userspace reads of this
> register is get_raz_id_reg(), which, while technically correct, as it
> returns 0, it is not semantically correct, as PMSWINC_EL0 is not an ID
> register as the function name suggests.
> 
> Add a new function, get_raz_reg(), to use it as the accessor for
> PMSWINC_EL0, as to not conflate get_raz_id_reg() to handle other types
> of registers.
> 
> No functional change intended.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
