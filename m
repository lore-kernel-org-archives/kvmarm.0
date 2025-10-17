Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B65266B56
	for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 08:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760690194; cv=none; b=oWolbQp6T6I2pG7UQDCtiqzrkxNyagjl/ws6u3dV+8D0/CpDdS78B0fU2v9AtOOih5FoA6thcaFKhPm9NIZphTKd5Kdi07A18RrLj+HGsHNO2Vonj8ImaN/oEQj7VzjpcbcUNS0lVLa4eRLneBqWkAqJF6NyVwJ6jFPLk84Azds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760690194; c=relaxed/simple;
	bh=H7neXrmmaHliUo9sEr0qz6ILP0qyJTC4U2kyqhJouQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W12B1nxhkXosjgxysOhX1/69NnbyU+p+fIxVVL54YP7utwXBv5mGhKBstftn6Kscr26VKPhtKF9lqThzQPQrUryHBW3hsxugHo4+4aDWIHv91wGQ0DUtcZx6BRA1Aft7BhJLmMBydtX88TB1gZYECQnuRYKhRYEb/r6MPucoK3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DOZCBIf4; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DOZCBIf4"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3ece1102998so1266502f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 01:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760690191; x=1761294991; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8PbyCiuHUJUF033svwvjOYrdhpWf8nguQ+4KJNq1qik=;
        b=DOZCBIf428QlD2d3SKdYwXgimtJqXoNR1dS8RKzj6/RhM9VlP1R9qLWxArBFZfiGC0
         lrVoJB7YYlFbHgeuruqSaYyXPzn9/2eIRFcYVSnjJI1aElvrV3LgVjtCaJe/qE+F9w9u
         78mGs19o1cBTOIZIlnORwl38MxaD3oyUzXKZAaR2p0IIgHkFua7iu/LskQwk+PAQt5op
         xqOtpbZ4WZlH0fRIrh+VJ3vWUYj//sO8RdYW/sKRX8rB6n8Jd2SngH78ybXWrpvptdI/
         5GRleDWZxuTBV4fcHtIKn1+KPgs/sYPE4Y4xiveIYv0fq3FJGQCKydCVbosjrepsVyrY
         Vuiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760690191; x=1761294991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8PbyCiuHUJUF033svwvjOYrdhpWf8nguQ+4KJNq1qik=;
        b=QR5CCpmhSJWZ9B8TeIhTNyAyqUzpFCm578NEPOq2upN1JQRdqcp91ZLYOXLH4mjKO+
         UTxD7vWZG69w9+KQ8VuKeP1iCSdnw/TeQmXgeUBoZrr+t1PzLP7qQdgpleANegoXGobE
         k7RG65FXlwTC91SgpcWkxnX7YCoEFO/kKdoiT4AhbxQLTwOGFEQByXpwYtNaAs+1TMvE
         3unuc8o4MR7fJpRR/yMjCTf+YCSLg9KmkrDAHIydKe5ImbCiX4K9GNMRw0rD0fWlCwhd
         ++3aA2etYYF8KaSIQV4ZndIP/yD/XIM3zszCUPEeMG+cobD9VphhaILrCc6J53f2RzuP
         wbbA==
X-Forwarded-Encrypted: i=1; AJvYcCXis1G0kOs7aFRbFVGKonwENz13LMl/WVZldnzKehUUYGy6Hu2gpHKatGM9+Y5h/5X44IrEHPE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCUnvjd3NfPQxe3N23eSknBvaYaIv3M4jTpOpExj47jgopvt8G
	ttwa1bFFc8dianrUI8KKjzCjsVBzj2nrITIZZHOxviCAQmz79Hrs42EHFcqToB1dIQ==
X-Gm-Gg: ASbGncuZ0s+sTl0eQQuv9MUYOUyVRK98gHKNcH9mus/ZRNSs1DCsOe7eB8QWdctNlzW
	QvLlBntRyAkOT6EQxQaDnKmFVzgGCZXRYQWptYrCoWhE1CXo4mAtPWUnDV441o2YCdBuKRIN2fn
	Ip+IcZpVWV6bTp1eBwjVlBcXORBBPDjtIRVqFo4xUbWOpndviDaRCt696tAxIJ4Ir1O8heDn+8A
	yCDaYYSRKBHfaTP60Ecjmpz53b23o72plA0o50iuGpF8l4CoWVG8xjmCOpNskrCQZMLn6sC2wOr
	aQmOVkwWSs8ayNcmQVaeUFPZy8ud3qXkemJC+neCl/UXylDPR/LSkJMCJSoFuZ7qumD0n6PXTjb
	iaSqcJhmPO2silobtDxj7Sss8WGGEkjnPqTriyS2sA3F8M+g6/1koJEMxGbkiP5I8+DagDDhLaz
	bUAy/9R99g81C73FLVMv3xf7vlLRgXk0idZo8+WJuv7MwfbOl7punoS5jc69oHmw==
X-Google-Smtp-Source: AGHT+IH72Zzon///3YHUGrfdJjvES6bGUL67+sdtzqRk2m12B632kNe5kfL2AL8JY16sBojJ3cT0Wg==
X-Received: by 2002:a05:6000:1867:b0:427:6a4:93da with SMTP id ffacd0b85a97d-42706a496dcmr779835f8f.49.1760690190913;
        Fri, 17 Oct 2025 01:36:30 -0700 (PDT)
Received: from google.com (218.131.22.34.bc.googleusercontent.com. [34.22.131.218])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42707b482b3sm2142688f8f.50.2025.10.17.01.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 01:36:30 -0700 (PDT)
Date: Fri, 17 Oct 2025 09:36:27 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 14/28] tracing: Add a trace remote module for testing
Message-ID: <aPIAC0WEVg1pVr0H@google.com>
References: <20251003133825.2068970-1-vdonnefort@google.com>
 <20251003133825.2068970-15-vdonnefort@google.com>
 <20251016170645.15416c8a@gandalf.local.home>
 <20251016171155.0d871fc3@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016171155.0d871fc3@gandalf.local.home>

On Thu, Oct 16, 2025 at 05:11:55PM -0400, Steven Rostedt wrote:
> On Thu, 16 Oct 2025 17:06:45 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Fri,  3 Oct 2025 14:38:11 +0100
> > Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > > index 918afcc1fcaf..52131d89993c 100644
> > > --- a/kernel/trace/Kconfig
> > > +++ b/kernel/trace/Kconfig
> > > @@ -1244,4 +1244,12 @@ config TRACE_REMOTE
> > >  config SIMPLE_RING_BUFFER
> > >  	bool
> > >  
> > > +config TRACE_REMOTE_TEST
> > > +	tristate "Test module for remote tracing"
> > > +	select TRACE_REMOTE
> > > +	select SIMPLE_RING_BUFFER
> > > +	help
> > > +	  This trace remote includes a ring-buffer writer implementation using
> > > +	  "simple_ring_buffer". This is solely intending for testing.
> > > +  
> > 
> > Nit, this should go up a few places so that it's with the other "test module" selections.
> 
> And when I tried to build it, I hit this:
> 
>   GEN     .vmlinux.objs
>   MODPOST Module.symvers
> ERROR: modpost: "simple_ring_buffer_reserve" [kernel/trace/remote_test.ko] undefined!
> ERROR: modpost: "simple_ring_buffer_commit" [kernel/trace/remote_test.ko] undefined!
> ERROR: modpost: "simple_ring_buffer_unload" [kernel/trace/remote_test.ko] undefined!
> ERROR: modpost: "trace_remote_free_buffer" [kernel/trace/remote_test.ko] undefined!
> ERROR: modpost: "trace_remote_alloc_buffer" [kernel/trace/remote_test.ko] undefined!
> ERROR: modpost: "simple_ring_buffer_init" [kernel/trace/remote_test.ko] undefined!
> ERROR: modpost: "trace_remote_register" [kernel/trace/remote_test.ko] undefined!
> ERROR: modpost: "simple_ring_buffer_reset" [kernel/trace/remote_test.ko] undefined!
> ERROR: modpost: "simple_ring_buffer_swap_reader_page" [kernel/trace/remote_test.ko] undefined!
> ERROR: modpost: "simple_ring_buffer_enable_tracing" [kernel/trace/remote_test.ko] undefined!
> WARNING: modpost: suppressed 1 unresolved symbol warnings because there were too many)
> make[3]: *** [/work/git/linux-trace.git/scripts/Makefile.modpost:147: Module.symvers] Error 1
> make[2]: *** [/work/git/linux-trace.git/Makefile:1960: modpost] Error 2
> make[1]: *** [/work/git/linux-trace.git/Makefile:248: __sub-make] Error 2
> make[1]: Leaving directory '/work/build/nobackup/debiantesting-x86-64'
> make: *** [Makefile:248: __sub-make] Error 2

And of course, I forgot to check CONFIG_REMOTE_TEST=M ...

The following snippet should do.

Do you want a v8 now (and with your previous comment) or shall I wait a bit more?

--

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 0c023941a316..aa305be834f9 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -665,6 +665,7 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
        fsnotify_create(d_inode(dentry->d_parent), dentry);
        return tracefs_end_creating(dentry);
 }
+EXPORT_SYMBOL_GPL(tracefs_create_file);
 
 static struct dentry *__create_dir(const char *name, struct dentry *parent,
                                   const struct inode_operations *ops)
diff --git a/kernel/trace/simple_ring_buffer.c b/kernel/trace/simple_ring_buffer.c
index c2ec6017c37c..02303161aab7 100644
--- a/kernel/trace/simple_ring_buffer.c
+++ b/kernel/trace/simple_ring_buffer.c
@@ -162,6 +162,7 @@ int simple_ring_buffer_swap_reader_page(struct simple_rb_per_cpu *cpu_buffer)
 
        return 0;
 }
+EXPORT_SYMBOL_GPL(simple_ring_buffer_swap_reader_page);
 
 static struct simple_buffer_page *simple_rb_move_tail(struct simple_rb_per_cpu *cpu_buffer)
 {
@@ -267,6 +268,7 @@ void *simple_ring_buffer_reserve(struct simple_rb_per_cpu *cpu_buffer, unsigned
 
        return &rb_event->array[1];
 }
+EXPORT_SYMBOL_GPL(simple_ring_buffer_reserve);
 
 void simple_ring_buffer_commit(struct simple_rb_per_cpu *cpu_buffer)
 {
@@ -280,6 +282,7 @@ void simple_ring_buffer_commit(struct simple_rb_per_cpu *cpu_buffer)
         */
        smp_store_release(&cpu_buffer->status, SIMPLE_RB_READY);
 }
+EXPORT_SYMBOL_GPL(simple_ring_buffer_commit);
 
 static u32 simple_rb_enable_tracing(struct simple_rb_per_cpu *cpu_buffer, bool enable)
 {
@@ -337,6 +340,7 @@ int simple_ring_buffer_reset(struct simple_rb_per_cpu *cpu_buffer)
 
        return 0;
 }
+EXPORT_SYMBOL_GPL(simple_ring_buffer_reset);
 
 int __simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer,
                              struct simple_buffer_page *bpages,
@@ -427,6 +431,7 @@ int simple_ring_buffer_init(struct simple_rb_per_cpu *cpu_buffer, struct simple_
 {
        return __simple_ring_buffer_init(cpu_buffer, bpages, desc, __load_page, __unload_page);
 }
+EXPORT_SYMBOL_GPL(simple_ring_buffer_init);
 
 void __simple_ring_buffer_unload(struct simple_rb_per_cpu *cpu_buffer,
                                 void (*unload_page)(void *))
@@ -449,6 +454,7 @@ void simple_ring_buffer_unload(struct simple_rb_per_cpu *cpu_buffer)
 {
        return __simple_ring_buffer_unload(cpu_buffer, __unload_page);
 }
+EXPORT_SYMBOL_GPL(simple_ring_buffer_unload);
 
 int simple_ring_buffer_enable_tracing(struct simple_rb_per_cpu *cpu_buffer, bool enable)
 {
@@ -459,3 +465,4 @@ int simple_ring_buffer_enable_tracing(struct simple_rb_per_cpu *cpu_buffer, bool
 
        return 0;
 }
+EXPORT_SYMBOL_GPL(simple_ring_buffer_enable_tracing);
diff --git a/kernel/trace/trace_remote.c b/kernel/trace/trace_remote.c
index dc6bc387ebca..e54cc3e75dc5 100644
--- a/kernel/trace/trace_remote.c
+++ b/kernel/trace/trace_remote.c
@@ -895,6 +895,7 @@ int trace_remote_register(const char *name, struct trace_remote_callbacks *cbs,
 
        return ret;
 }
+EXPORT_SYMBOL_GPL(trace_remote_register);
 
 void trace_remote_free_buffer(struct trace_buffer_desc *desc)
 {
@@ -910,6 +911,7 @@ void trace_remote_free_buffer(struct trace_buffer_desc *desc)
                        free_page(rb_desc->page_va[id]);
        }
 }
+EXPORT_SYMBOL_GPL(trace_remote_free_buffer);
 
 int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t desc_size, size_t buffer_size,
                              const struct cpumask *cpumask)
@@ -960,6 +962,7 @@ int trace_remote_alloc_buffer(struct trace_buffer_desc *desc, size_t desc_size,
        trace_remote_free_buffer(desc);
        return ret;
 }
+EXPORT_SYMBOL_GPL(trace_remote_alloc_buffer);
 
 static int
 trace_remote_enable_event(struct trace_remote *remote, struct remote_event *evt, bool enable)
