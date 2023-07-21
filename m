Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13CC27F00
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 17:50:08 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-bc68c4e046aso2045232276.0
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 10:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689961807; x=1690566607;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cGq520d0DqyrCnCF7s5Hdb0rD6NYwtkYzvVScy9HYVY=;
        b=lZQ3ytVABaMbgeRDyRyj2Y4aroG9rwZE4tos1KIi9+yVur8kHjUJfNDjBsWbA5klWv
         TLcM88saeccS8fNt+F3rMDPeeLUphdScBaSRyrIwijc1R9havyOwlUNE/IQcuJNK+B8L
         fg4nRh9mVWUewpR8WoS4y2UShReGqGQI/p2sPXI0/xi9S/4bLyRSoR+wjHm8ngFldPX/
         svRbdc4YBfOK5kZ24vC9n3F8L7Li2/2X6A5zsHfs5DeCFBQGgpDd6R/Lv+3ONLhdKh+D
         zucg4UeBA4sEAN2XLHlR2RolIKqE8NS9aws4SoQANyJbQckavpkDoby1VzLjItanYN4z
         z0Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689961807; x=1690566607;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cGq520d0DqyrCnCF7s5Hdb0rD6NYwtkYzvVScy9HYVY=;
        b=iBxvA7WSx/xUXW0i6IUQZYzOOy2x3X8oAVe6RZrF7X+8mlxNnj1D9UwuZepTZ5ZpDV
         Z2P8OC9raM+Asj6H7ZrjZczrir5QKnixg8wFgtCmqoAmyC1nJOO/YDtk+2i/OZauFpzF
         7/hXiUR2l1TyUGLUWnO6Iw0JQUb6dmSnLCziZ4Aoe7QE8KWDcEXo+Gt9IVIGbis9AaQG
         asSCj+xxPF5FBWOmDByPqgAGJsIb5G9QsTD8UyI/K6oHn7wRIGPlcAh+QcAs2f3Fq58q
         i6aYmnmJ0XFu9miUCUUNO0fiXcrqR1iEO43HGA2CNItc9Opd/I5x+kCCT6B0gVopNc/O
         YsPw==
X-Gm-Message-State: ABy/qLbbVee4aP6FsfHeQ2fXeMnNFS2S/l2FfeWhiwSme4lH+LrZa3Ym
	ftYW1MllR+kwrH/zndDFd4O0YIZ2QIc=
X-Google-Smtp-Source: APBJJlGQVjm5RzrpH36bdluvnqR1OmovIF/Mv2HtKZQ0PUD+Zj6xyTxIa85gQ91Vm5Bag6YHDA7hXUEb4so=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10cd:b0:c1c:df23:44ee with SMTP id
 w13-20020a05690210cd00b00c1cdf2344eemr19769ybu.0.1689961807734; Fri, 21 Jul
 2023 10:50:07 -0700 (PDT)
Date: Fri, 21 Jul 2023 10:50:06 -0700
In-Reply-To: <8ad7a846-64e9-a3f1-4bf1-731a994d62cb@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <20230718234512.1690985-13-seanjc@google.com>
 <8ad7a846-64e9-a3f1-4bf1-731a994d62cb@redhat.com>
Message-ID: <ZLrFTq2f1NXtlJWd@google.com>
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, Vlastimil Babka <vbabka@suse.cz>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 21, 2023, Paolo Bonzini wrote:
> On 7/19/23 01:44, Sean Christopherson wrote:
> > +	inode = alloc_anon_inode(mnt->mnt_sb);
> > +	if (IS_ERR(inode))
> > +		return PTR_ERR(inode);
> > +
> > +	err = security_inode_init_security_anon(inode, &qname, NULL);
> > +	if (err)
> > +		goto err_inode;
> > +
> 
> I don't understand the need to have a separate filesystem.  If it is to
> fully setup the inode before it's given a struct file, why not just export
> anon_inode_make_secure_inode instead of security_inode_init_security_anon?

Ugh, this is why comments are important, I can't remember either.

I suspect I implemented a dedicated filesystem to kinda sorta show that we could
allow userspace to provide the mount point with e.g. NUMA hints[*].  But my
preference would be to not support a userspace provided mount and instead implement
fbind() to let userspace control NUMA and whatnot.

[*] https://lore.kernel.org/all/ef48935e5e6f947f6f0c6d748232b14ef5d5ad70.1681176340.git.ackerleytng@google.com
