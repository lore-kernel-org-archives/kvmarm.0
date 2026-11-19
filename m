Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795092225;
	b=FzC62pqgfLFEoXJr5FVqMZEqSWzoRoIiB02ce2f4baMMhgmwriTsLOkNtP5eEPwGJY4L
	 UTCBv6viLn6ayPGlcg2+q4ii/3Sg8l/KVfuk+Thfn3YBL0VaqXFr7xd9YKYKIcjGoOVWr
	 YnT7a/UxC4EwjePmuzm+TsVj8NYEwMV4+UaHNfcGSNjr91eS8VuCazdMI6frL/ghN3y5h
	 +aXR8zHvHzw/n2PzoZ5oWE+Errwr16LJM/SVS+hr9h9RXFA2HIm/YZTHqmxO74ZLCILkD
	 SMfQoDMZjVeN+AvvGraEITzvjbZz6lvuYQEZ0jr4OR7+KSIbIhUqwdR6ea9KjH/qRag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795092225;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=+mOeVpvRBA6/46O5gUxxVFZ88WfFegk/q5O3KpOSYyQ=;
	b=XQEPoCcXyItNjI3vWnYqF8zL+XfH0whkum28v3Mb5fE+ITaontdpBJaML2ym21YOXv5v
	 omURGw5eFd1oHF7gvO+O0FgeWOE8ggRa3LGG5z9oT+O0ibgtYztrX2p0jMJoHoL9p/SIA
	 XK1dEObSg6mdlxLVkKmHB1e///DcyJhLKayyZx5tw4w6+YQMXKy+iqheDfG6L7erRFUaW
	 Cej5NOq59F+oQ6ok7XCrnGweVXrpdsC9iV3tutNcCXS1lV4YU3lLQjtOXejI2TMgtnq+c
	 GDnAfmcg5yGG6aE/8cFkPDzSsQttBpeE1pymnuEjwV5jcalEdKpxeNT7jvjOUGTpTxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=giT8vF9X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E352C606A333
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 12:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=giT8vF9X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94B81F000CA;
	Thu, 19 Nov 2026 12:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795092224;
	bh=+mOeVpvRBA6/46O5gUxxVFZ88WfFegk/q5O3KpOSYyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=giT8vF9XIYLphfHxRXn7q26XJPZrcugkYGL4j+Bu56ZY/1BNC2KmVWHJYd+wwuHNt
	 GusMXDh2FpoCgxyPzKaDshBUwzqOjG+o9BubKwSs19mmii0pV5sAdZaEieIvrAeHuS
	 RxHqjB3bYocYlXxURioNZSLrKHIWdPF+tg3HE/S3ir5GKs09JZDCESWd8LUJp8jdEA
	 EI5Rh7JFPdB1kGePFKY5e6B6Y5FCkTAFn1TQv4FkJ5bqqtgya/uhGKWmtsl3EzlSXd
	 5aAFLpM6emUl2+kY7uhxg/GzMEQPXXtWTMi1pZpNxJDMZtcaLbRXtq1ikV/7sRZQ0p
	 vZbEFgIwR3qVA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xU1UN-00000000RvW-008r;
	Thu, 19 Nov 2026 12:43:43 +0000
From: Marc Zyngier <maz@kernel.org>
To: Congkai Tan <congkai@amazon.com>,
	Dan Carpenter <dan@pereq.eu>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Haris Okanovic <harisokn@amazon.com>,
	Joey Gouly <joey.gouly@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Stanislav Spassov <stanspas@amazon.de>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?UTF-8?q?Cl=C3=A9ment=20Blaudeau?= <clement@cryspen.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: nv: Fix a couple NULL dereferences in kvm_inject_nested()
Date: Thu, 19 Nov 2026 12:43:33 +0000
Message-ID: <179509215916.3938200.9104280660792618506.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795006659.git.dan@pereq.eu>
References: <cover.1795006659.git.dan@pereq.eu>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: congkai@amazon.com, dan@pereq.eu, catalin.marinas@arm.com, fuad.tabba@linux.dev, harisokn@amazon.com, joey.gouly@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, oupton@kernel.org, stanspas@amazon.de, seiden@linux.ibm.com, suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com, karthik@pereq.eu, clement@cryspen.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 18 Nov 2026 16:05:38 +0300, Dan Carpenter wrote:
> This is part of our formal verification work at Pereq.  It's a couple
> of NULL dereference bugs that affect nested virt.
> 
> The first version added checks for if the vcpu was loaded but the
> new version loads it unconditionally instead.  Also add a fix for
> the related bug that Sashiko found.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Load the vcpu in KVM_SET_VCPU_EVENTS
      commit: 5651590be08a6dc7e36cbef415c8f23af1cda4d9
[2/2] KVM: arm64: nv: Fix NULL dereference in kvm_pmu_nested_transition()
      commit: 09edd2a7ed8a1aaae8e472ab11313faab9f401cc

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


