Received: from mta1.migadu.com (out-149.mta1.migadu.com [95.215.58.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06DA448B8F
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 14:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787235110; cv=none; b=Wrc94UDfGO8lv5RKYc79Esfyq1Mo9x01X+IUVQds/f1OuiGNdePOINB4PkXNSqPZ8TCoT+oYhA8PTUY6aoJYG8luGmUQOMh6OqrnvDEu3lP6rZAfoQL7VlEOb0jjLjEjh4QjpM5enpv3kkC/qjedgy8jtN8JDK+pPzzPpaU5sVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787235110; c=relaxed/simple;
	bh=/FPeC+iW5UnCRy3xNOXJa0cp1E4xq5bXCrysjGn7FHc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NjWPxWsradL7/8ReFaS4cLutI/uENyKvCPb/67MEDJ7Eq2xraLkDCcEgnSFb6DLSijEQEO8dDuOvmgg7tOBuHNcKM9h+50yltEfeyZNFc0kULgWxI8OSQ+YKQCC8s38/83kBN799v9Oxe8eot7vo69DmnauvbVeEjj78ENwZln0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MUcuZ5B+; arc=none smtp.client-ip=95.215.58.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MUcuZ5B+"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=/FPeC+iW5UnCRy3xNOXJa0cp1E4xq5bXCrysjGn7FHc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787235105; v=1; x=1787839905;
 b=MUcuZ5B+bQ/6q2hzqUjqpoAm7QKM+Cn72hVWsuQ/T7wGMmhqgL2DK9rP4jIuTjxJG29VkB+k
 zkg9W3cGYr5ED2+AyAQX4x4GW2jTUQOQ+yKI7rfpYP7zkdx7UqCyfQL548WZgLgZ2nd3ZcwUd2c
 rSXeeFm5L0Hca83GWQFQrjjU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f44.google.com (209.85.167.44)
	by smtp.migadu.com with ESMTPS id ca404f41df95d80c;
	Thu, 20 Aug 2026 14:11:45 +0000
X-Mizu-Trace-ID: ca404f41df95d80c
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so11033e87.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 07:11:40 -0700 (PDT)
X-Gm-Message-State: AOJu0Yyr8WrZuWTSqYOGuTCahWb6XrN4fVJo95iM3Q1isWac0gpG6I9r
	APEW0Q8tAQ6BWvYqCBAbAYDsy9hEw6j9S+p0iOBeztRGlSr0z8k2nViCXOn0DVFfyZ88ISE5TnB
	R8C2D4pjsjaKuBBs7FG4QgZ2YpMS+/lz6sBg3rIsu
X-Received: by 2002:a05:6512:3409:b0:5ae:a4e8:47be with SMTP id
 2adb3069b0e04-5b47dd9397cmr193818e87.7.1787235099874; Thu, 20 Aug 2026
 07:11:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260820125053.2951078-1-fuad.tabba@linux.dev>
 <20260820125053.2951078-2-fuad.tabba@linux.dev> <20260820130616.1A7241F000E9@smtp.kernel.org>
In-Reply-To: <20260820130616.1A7241F000E9@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 20 Aug 2026 15:11:03 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzf4C6bdwTGWNN1HeapFWEFWm-AJtxi5gQKHekRS2n8Aw@mail.gmail.com>
X-Gm-Features: AcwNN1UO4jbfDArvCU_vsJPDoyO_q6tXOzTT6hgONE-IadCE9Lo9ihDN9V0SpyU
Message-ID: <CA+EHjTzf4C6bdwTGWNN1HeapFWEFWm-AJtxi5gQKHekRS2n8Aw@mail.gmail.com>
Subject: Re: [PATCH 1/3] irqchip/gic-v4: Clear the domain and fwnode pointers
 after freeing them
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Oh Sashiko, here we ago again...

On Thu, 20 Aug 2026 at 14:06, <sashiko-bot@kernel.org> wrote:
...
> [Severity: High]
> This is a pre-existing issue, but does this function permanently leak IRQ=
s
> and SGI domains?
>
> In arch/arm64/kvm/vgic/vgic-v4.c:vgic_v4_init(), KVM intentionally trunca=
tes
> dist->its_vm.nr_vpes upon failure to allocate VPE IRQs:
>
>     dist->its_vm.nr_vpes =3D i;
>
> This limits the teardown loop in vgic_v4_teardown(), which later calls
> its_free_vcpu_irqs() with the fatally truncated nr_vpes value.
>
> Because its_free_vcpu_irqs() relies on vm->nr_vpes to free the IRQ hierar=
chy
> and SGI domains originally allocated for all VCPUs, the truncation causes=
 a
> partial free.

Looks like a bug indeed...

I think the problem is that vgic_v4_init() overloads its_vm.nr_vpes:
it truncates the count to bound the free_irq() loop, but
its_free_vcpu_irqs() reads the same count and under-frees what
its_alloc_vcpu_irqs() allocated at and above the failure index.

The fix I have in mind keeps the two counts apart: teardown frees
everything allocated, and free_irq() only touches the requested
doorbells. Marc, what do you think? Something like this (not tested):

@@ vgic_v4_init(), on vgic_v4_request_vpe_irq() failure @@
                 ret =3D vgic_v4_request_vpe_irq(vcpu, irq);
                 if (ret) {
                         kvm_err("failed to allocate vcpu IRQ%d\n", irq);
-                        /*
-                         * Trick: adjust the number of vpes so we know
-                         * how many to nuke on teardown...
-                         */
-                        dist->its_vm.nr_vpes =3D i;
                         break;
                 }
         }

-        if (ret)
-                vgic_v4_teardown(kvm);
+        if (ret) {
+                /* Undo the doorbells we requested (0..i-1)... */
+                while (--i >=3D 0) {
+                        int db =3D dist->its_vm.vpes[i]->irq;
+                        irq_clear_status_flags(db, DB_IRQ_FLAGS);
+                        free_irq(db, kvm_get_vcpu(kvm, i));
+                }
+                /* ...but free everything its_alloc_vcpu_irqs() allocated.=
 */
+                its_free_vcpu_irqs(&dist->its_vm);
+                kfree(dist->its_vm.vpes);
+                dist->its_vm.nr_vpes =3D 0;
+                dist->its_vm.vpes =3D NULL;
+        }

         return ret;

The actual patch would factor the shared teardown tail into a helper
rather than duplicate it.

If you (Marc) agree, I'll send this as a separate patch (after testing
it), or as part of a possible respin in a couple of days.

Cheers,
/fuad




>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260820125053.29=
51078-1-fuad.tabba@linux.dev?part=3D1
