Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9AF2772A
	for <kvmarm@lists.linux.dev>; Tue,  6 Aug 2024 18:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722969917; cv=none; b=D4/t8sPUnb0UZBiYFSi3L0OLy1DBARtibAkpLkD1qfyWmD+rU9tYinXHh+kGM5MsUBc7RAngukB00WziMWtdT1zVSlngzKyqsqcIo8NTAn+wfh2KICOxYbO+Kbf8FYgH8Hw/l1MeR9y19o0WY+rMytN3zljfMa702MwEK8nMHvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722969917; c=relaxed/simple;
	bh=jHsGt2Ecfc0zM2iKA6jysW31IutQSfrosXB8X1hXSNQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p7r5WoaOydZOJvoLJZLfDipFXMmnf3o9oqP4LyWeAO8/LMiBO0evo5D5X8D4LyamE60h5N6Wb+KRJ0X06mXd/tXsXsqSKis2TOn+jf8tC/sDXmIwMOQbLI/qGw6hFm5KQpCf0tT4TSrmprq3VVbJ5Zi11kbdObb0+yG2IawIbLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FkemG8k0; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FkemG8k0"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5d5af743b8fso534047eaf.3
        for <kvmarm@lists.linux.dev>; Tue, 06 Aug 2024 11:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722969915; x=1723574715; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ripeo5i8uUp5SgHoOewxiAzj2BIopxPTD9L1SwZcR+A=;
        b=FkemG8k0VGTbyYTK77ni5MGeU1zJaPOFXOZiurCp8weg3L9KDMzb9eo7iIwOawxSPB
         6GnB5jWYl8b1EDlxixFoh6B9MfTA5l9wW+vI3xfins+ZkQmKDiEelRyBy3YbGlNqlSEY
         lvTzAv4aWffjzxCydwnPXJXsHkYuDT2Y3li9CX+UnQL3s5HoS7j11MjXhGEqYhTOPaQb
         i/+85L91Ht43T7DThM3EwMZbYk+3hAzFgqyltn5hdT2X7323B0R3qlPgKiGsayQf/rYl
         SUZFIBvELShQvc5TRIeDlLy1X7gt9eG1jlC9zJeDElYukSKqyDPywtQ7FBVG2FZB1h+H
         zG0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722969915; x=1723574715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ripeo5i8uUp5SgHoOewxiAzj2BIopxPTD9L1SwZcR+A=;
        b=BSFx/munVA9DEWZqYM62qCMj15CP6AsiChrrO1bH1aVDxx+O+d3rpHDIvp75TO0Ndq
         46jaJIacP5LN9HxE7O/OZKOcVW0oT2azSMyPhVpTluj7V1U4CPZghUV+RoX7hnYexXhT
         dVUiUCIQE+98O4HuPb/9BL27d8XeL8JqoQcj2JLpm5dSZeQAGSks0D6+kj9L/8zlo/iM
         0c6aRy7qdSsDlPIz0DHkMDsiNE5K2UF6EIDj/y5RjkxNuij7nPjFM3rILBnNGJCJS5Pq
         jwecDcSb1+36W69o/oeAWHN/D+hOKDagYPszmjK0F2D7DJPWbf6C2JfONwJ3PVcyuS1L
         dB4w==
X-Forwarded-Encrypted: i=1; AJvYcCXq/rgDf+u813pkU4dk0ZtHJ13H+7qCgPPOwRxccRVzF8lS6Ph+h1pwuw9ktn1LfBki01tKsd6V1PbsUco85IbaWpl6Gvnn
X-Gm-Message-State: AOJu0YwGJYA0b+EtWp5TLr29tUvuJAtbgislZ1dPValgeFvO8k/n6/3W
	9B8jo9OkXAhXH4HFKp0UxGuTxoLYI4NnmTf1nbeNUTpByPfAN7Dh0eBC7NUp39cyxFFcIgqeUOK
	3V26PbGbP3ZyEdvtIdQ8GbhPUsW9tEJwv7AFi
X-Google-Smtp-Source: AGHT+IGC4aXwtfPl59UuB0qcraDI6lRBACElZ10exivMH0tQxNylIzGJybb+jLBgrGRQqnhyIwoOBZqIWA3F4WkOGMI=
X-Received: by 2002:a05:6870:9a1b:b0:261:16da:deca with SMTP id
 586e51a60fabf-26891d40b76mr17350382fac.27.1722969915146; Tue, 06 Aug 2024
 11:45:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240802224031.154064-1-amoorthy@google.com> <20240802224031.154064-4-amoorthy@google.com>
 <ZrFZ_ANIIbFdzmIn@linux.dev>
In-Reply-To: <ZrFZ_ANIIbFdzmIn@linux.dev>
From: Anish Moorthy <amoorthy@google.com>
Date: Tue, 6 Aug 2024 11:44:39 -0700
Message-ID: <CAF7b7mps9-HdBv52BDbAMceGuT+FRiRtpdwpK=psfW1Msvip+Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: arm64: Do a KVM_EXIT_MEMORY_FAULT when stage-2
 fault handler EFAULTs
To: Oliver Upton <oliver.upton@linux.dev>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	jthoughton@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 5, 2024 at 4:02=E2=80=AFPM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> On Fri, Aug 02, 2024 at 10:40:31PM +0000, Anish Moorthy wrote:
> > Right now userspace just gets a bare EFAULT when the stage-2 fault
> > handler fails to fault in the relevant page. Set up a memory fault exit
> > when this happens, which at the very least eases debugging and might
> > also let userspace decide on/take some specific action other than
> > crashing the VM.
>
> There are several other 'bare' EFAULTs remaining (unexpected fault
> context, failed vma_lookup(), nested PTW), so the patch doesn't exactly
> match the shortlog.
>
> Is there a reason why those are unaddressed? In any case, it doesn't
> hurt to be unambiguous in the shortlog if we're only focused on this sing=
le
> error condition, e.g.
>
>   KVM: arm64: Do a memory fault exit if __gfn_to_pfn_memslot() fails

Ah, right- forgot to address this before I sent it out.

Basically: those cases you mention (besides MTE, where it seems simple
enough to add an annotation) happen before vma_pagesize is calculated,
and it doesn't look trivial to just move logic around to do that
calculation up at the top. Lmk if there's a good solution here, but in
the meantime I'll just take your suggested shortlog

[1] https://github.com/torvalds/linux/blob/master/arch/arm64/kvm/mmu.c#L147=
9-L1514
