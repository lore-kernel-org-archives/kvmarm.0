Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7782A1FC7C8
	for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 18:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736880000; cv=none; b=JgRN1YZy1iNua69q2x0QC+bXv12RmYEUqNrUdYuC3xwRHzXaYtqi524WMI8lpFvrqsji+aZmXC4VTp8BUoov6D6a3fgdVmtVtq5/b6GZgfa5evm8PLb/pA6aqPvxWcB6mLASQqqaEMyHmsyUhtiujBW961TVU+Y233dzXTffzLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736880000; c=relaxed/simple;
	bh=Pq4VB2co6DlDAkufGeGEI1KHrnsWOp+YIDepto+qbd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iv6MGPZqXHW1mqnfdE0hsTUKF6ekKLoPYVgiXwK1V4vyUrkP53W8pmz39Tls+P4nMH8NeqvGiCdwzRM5ShDOqEKSuYksktozH2jXbOPqeGVWbKEaZXpZzxUSijCdhPVLESAgfSxR0espcEAEWO4YmlCBCHugNQKCGeBSGBn+Vs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LuUcJe8N; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LuUcJe8N"
Date: Tue, 14 Jan 2025 19:39:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736879995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=97WDxuRYiWyXD8yAfu0zZqcacG47H/1aDD9ac4aHZlM=;
	b=LuUcJe8N3NNsLgNnpBIEndO1e8RFDX3UzQ60SV9T974sgFU7FKx6PrAoiVi+cMOHyqjTX3
	+O7D88uR48oFxr5fTzbpYw0WUbRmzLezjmsAJthOY9lo5+6xPs/UhdtRlFWndrGVmWDiEj
	JrN7xiQADyTXP/lFRwjSge76XevVY7U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v1 1/5] configure: Document that the
 architecture name 'aarch64' is also supported
Message-ID: <20250114-10fb4c9302167ef202e98713@orel>
References: <20250110135848.35465-1-alexandru.elisei@arm.com>
 <20250110135848.35465-2-alexandru.elisei@arm.com>
 <20250113-0fe04c6089726d1d06a254ec@orel>
 <Z4aY2AKSaxKDY5Hq@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4aY2AKSaxKDY5Hq@arm.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 14, 2025 at 05:03:20PM +0000, Alexandru Elisei wrote:
...
> diff --git a/configure b/configure
> index 86cf1da36467..1362b68dd68b 100755
> --- a/configure
> +++ b/configure
> @@ -15,8 +15,8 @@ objdump=objdump
>  readelf=readelf
>  ar=ar
>  addr2line=addr2line
> -arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> -host=$arch
> +host=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> +arch=$(echo $host | sed -e 's/aarch64/arm64/')

Sure, or avoid the second sed and just do

host=$(...)
arch=$host
[ "$arch" = "aarch64" ] && arch="arm64"

Thanks,
drew
