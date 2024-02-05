Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9794A9B0
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 21:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707170189; cv=none; b=s4ni3GZVGXAsUb5HI+SMQUt+wd05yow4xYYDjlr5sejGdcNEQUWuFZpD7oaxJEwvSwtLBYrs+O9GLrV3txm5DvoywRoO3UhuqAzuj8wrFik+xwrMLSA9qB0kCpEmVt2kFnzX6HpffCPI8KwN8ZblyPsMzfTfHNx86CDBnrs/k8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707170189; c=relaxed/simple;
	bh=LQnuxU1HCojSqMw5PprB5FS4EXyL1CKa2bYivcpQ2Lg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=a6N42MVGrHb3N3nKpqevr6ZXjf43TJJilWmkps3xqct0jP2n7JQKcGhlr4bKs+pO9Rp2Wuitrf6EOECamxqnphN7WM/zCdYQNOtG6BXzybD0/PVk1jeHictXjVj5sWfm2pG+2FVuL8Z2j82F0hyV07ObJQ1nt0KiT5mMaUcADg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IB3aXiqB; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IB3aXiqB"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3bbd6ea06f5so2038004b6e.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Feb 2024 13:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707170187; x=1707774987; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LQnuxU1HCojSqMw5PprB5FS4EXyL1CKa2bYivcpQ2Lg=;
        b=IB3aXiqBvaWRQbsvJNkDqj5iU8o3mzxxjrRrzRet1Q8l2SPRjo2CbidiaPn/q/Imtx
         V9UUnTn3ej3A1PWXttkdDWEC+P8AUOzgmT8V/g4Dwfvg2yCiExOIX5db/ZeC6zMwwJId
         ko+N3oxzgzwrP61yh3XQhOEYCgHhWY4WCat+bTVmgGc1xPM3DICaXhjXOeFNR6OXHrNp
         mDN/5V1fti8wXb0hvpEix6tL7tysJmRplULh0Yar4JfDrowj5ICYBV/MMzml7ozZMRuW
         qr+NspvPFOQbvtFC0o8psiNFo/6ai5w3+m0Z/2s0LE6hgpkhXc1P8CEBzWNd92CXQZVd
         +LTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707170187; x=1707774987;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LQnuxU1HCojSqMw5PprB5FS4EXyL1CKa2bYivcpQ2Lg=;
        b=bIQ7PaMKvEHU6iVovUme5Kul+JeDVs3xVAP2/W/zm1lM78z3jOWMtgnkLaC8me4n0J
         37PaDfk/LldviX+GmgglABHe4MsS/pjJpW3Zphieu2qJ9v+XHnDYmrtJ9rqQpfDD6BPl
         MF0rYdfPxg9urfwM5mIC60/6sW0p+sZYW+ytEEW4RRhLC447VLh2bBho6TaPOTCcQ0Ag
         +3XJRmpgI9Ca9WCGqqOqYu9OqPutPhMF/qhy3DV5fxMScVRm0pUuNYw4XKDqzCLx1jWs
         nypXkE5ejxbkYgiLJXZHsEvutIJ3novVjaxz/NF9+H7CGJ4pTHlMGxG3XqKOSkRaf6zl
         Y8Mw==
X-Gm-Message-State: AOJu0YzGrz9SCqel53ytzOBNKlM1rij9WrBWHNbGjimLjBuMStlpHgXA
	rEzyr2E3HUldoy/OueZdfvH6oblkJkJHEZJt5qFRp7F74VciUUIFyixYrbP3FAVQ5wmUEdYczTD
	210NrWAwbJg0dHNqdJPkpT6vRQtOQjy7ui8y7
X-Google-Smtp-Source: AGHT+IHJCzG1k6t5OdcSqCWDVM4SOxp7IeB0S7XvTeXg+mqlm+3/G/Uf+RVBY398zcSVCl+WtTQmgetcUCIIme3Sr3Y=
X-Received: by 2002:a05:6808:44:b0:3bf:cb83:76a7 with SMTP id
 v4-20020a056808004400b003bfcb8376a7mr450140oic.5.1707170186948; Mon, 05 Feb
 2024 13:56:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-6-amoorthy@google.com>
In-Reply-To: <20231109210325.3806151-6-amoorthy@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Mon, 5 Feb 2024 13:55:50 -0800
Message-ID: <CAF7b7mrOuBS=nOAy5QbVpR_TzsOG4Kop+_TiD7EZVYATvtWFDg@mail.gmail.com>
Subject: Re: [PATCH v6 05/14] KVM: Try using fast GUP to resolve read faults
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Dropped as per https://lore.kernel.org/kvm/CADrL8HXSzm_C9UwUb8-H_c6-TRgpkKLE+qeXfyN-X_rHGj2vuw@mail.gmail.com/
