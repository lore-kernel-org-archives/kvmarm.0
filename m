Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA9617ADB
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 23:48:53 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1b8a7734734so32264885ad.2
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 16:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689724133; x=1692316133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SDxWIrfosG9XJ1i6+ao4lNZmMm/71hk0CPfpAh3rles=;
        b=oKgQFwiCrPvHzuuXJTxGw9fTJQCZKL9TyIsnHUo20k7J6vJr/dP2UuT8GyfaXNhKWl
         lfnwI4SNZlla+krW1fx/4HTGrmx9tbRfRVWIu3HGnyMHAJnHjaH8b3Nn7OD9lub8Upfz
         ScGl6hIrQNtyqOKMdvwG71E9U1LJYrTTZQq71Kwv4L3GIqczSYB1Q2ibrVYwZRMv7ks2
         QNhyu3W0Ns8Grpmlyc83iZpzHpUsL+aloKwTrirYI0WDq4iN8t2n8ha5cP4AK06m8uQ9
         dXuqm5q+qG2yKgB+nUEYuog82s4uX9rRPSCnrZx4hsx8m3v5+ZWIujkgaic/poWXwLCP
         o9Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689724133; x=1692316133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SDxWIrfosG9XJ1i6+ao4lNZmMm/71hk0CPfpAh3rles=;
        b=S0mkRo+S6yufZj2vMFdudj8zVAjCy0SHo2BN6yhiKPiKKSMDmh5Dk17ibpUSeGP49H
         q4WY15YgmMuAgvSU3pfmRbJkAIIvKYB10ncYZuAi/WhDabolMS1h/Iz6giE/mcvXXuR7
         Luc+OBhcQmEVOwk8ROKgZFSibs6FBQ6mhaL01D77mdQ+fWLW8gk2nEkmKGuI74lS5pUC
         5UxEDLTC8BsxnyBCcgGcjRPMz+ug9ZMONCx7a+OijYnYvYCbdmf5mIXqnyNWiKifWymB
         1BfXTLGYzlRd+7oyMVXdCAbX6LRw+irVtqiRoGH3lThOy/OSWcaamtviN+44CMPIug2D
         W0cA==
X-Gm-Message-State: ABy/qLZWOSYkGR2wQiY8C7MOikQSIXa2ShbwQT9smIQfbmIPNxjit/j0
	N3NkQdj0VjQf3YHT0H12njV666DiKmw=
X-Google-Smtp-Source: APBJJlFRkrJKR6wk6kjyyawD9jUVadK517ZfNP5yf1yjj9/O0JQ+6He3HEMs3LUDgHlJok/ugi+AWDRSDQU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c412:b0:1ba:1704:89d1 with SMTP id
 k18-20020a170902c41200b001ba170489d1mr21516plk.10.1689724133087; Tue, 18 Jul
 2023 16:48:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Jul 2023 16:44:54 -0700
In-Reply-To: <20230718234512.1690985-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718234512.1690985-12-seanjc@google.com>
Subject: [RFC PATCH v11 11/29] security: Export security_inode_init_security_anon()
 for use by KVM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 security/security.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/security.c b/security/security.c
index b720424ca37d..7fc78f0f3622 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1654,6 +1654,7 @@ int security_inode_init_security_anon(struct inode *inode,
 	return call_int_hook(inode_init_security_anon, 0, inode, name,
 			     context_inode);
 }
+EXPORT_SYMBOL_GPL(security_inode_init_security_anon);
 
 #ifdef CONFIG_SECURITY_PATH
 /**
-- 
2.41.0.255.g8b1d071c50-goog

