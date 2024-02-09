Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09860657AE
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 07:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707462125; cv=none; b=lSNiemPlr6J3iAc0X1J4azzYGUgnJNL6m5nOMRHmdDYUWxHvQixVFOaYoROAwMXypavyaK1CHUGBEMAKdP74t2n2prIy6XG7WSf8LOYOz/ztcIFJh/DVSe8LsVrU7X30gBh+x9scJWmffiBcsz3cNwsSTKHA5wHK62PVMOSqOCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707462125; c=relaxed/simple;
	bh=UVP1Wum4p+fkBQmbGH46gx3YuxcNQtb06PxYoUjG2iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GU4gHi6O7qTtPdffQ341lIydhBK08+mZhtqKeqqnaBql8X59wkNr/TNe35obAe1gtbfQK/vw5VZ3XY7PaC3njqxv7ImQUmWnM0oAN4V2uF5Bss+7ej8mw8s75Y8AsKd23y4lBKWAqC/FTsKco52Suo6vCuLxrwsi6MVVen0Re8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eZsod1Gh; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eZsod1Gh"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5cddfe0cb64so403307a12.0
        for <kvmarm@lists.linux.dev>; Thu, 08 Feb 2024 23:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707462123; x=1708066923; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eL749GGZxcw+dNDSidA1ZYGeUwGyyiY2EeTAJqo21lY=;
        b=eZsod1Ghr9HK96dZ8zlQn8EuBtlgVQ9xycJHo/DCO3esJ3Anq05Y0Vmsmk7FRqDXBy
         DlFfJOI1Nuye7YKHigbxRyPbigz7Jk0TC/+CJ3tjitdFyBSEdF+bQK1wh/hM9toLmoEj
         eAaWfZ6kIvQKRK27cRMfNfGP7XVR1kmWM/RMyuEyCG/NV12Z413Hj6Gw9vLrsbayVwX+
         43R9PyK8To6dP2xjJseUQ0H9T5QcRoWhhS8rL2vujPRQwd+yqtmaZ/g9oY/HFhoUHYuh
         7OF7js/3cmOFL+IWhUs0lUQt2r1ix1npYe3dJXaEgbgqZ/6oJwL64t20EWLG2OFO3L0m
         rWZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707462123; x=1708066923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eL749GGZxcw+dNDSidA1ZYGeUwGyyiY2EeTAJqo21lY=;
        b=TNC+Ei83kxSoI9v3AjSs1ewGzqNCHY0o6hU1EeDHtEbuQhJ9txD0ZT3CPa98pNx3Gy
         +2TxHX9ZcyV5PXsZfMewL0Tctlrk6jeSWupGmf3XEcvbHodoTl7FfTo6Z2v4dSf67KKU
         6LWHVcjM0CcRU0oOHqJqHMD78VN4Lrgz5+FOXjt8b+nw8Az9KUA1lL5SxQEQHN5+YONC
         x9fHW0i1WxmAoTOOXmFfPcnbNG6HiVEj4LV1S4Q88YZ/XQXjxCkwi0CDgVCifTBbnSq2
         gzn61ZrL6VE/rlFcZy6+GzoFLQOuc3FhueP0lWsmkXRUTpKB9V5zDPmbztLZ58HU6vpO
         XvFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgINyp9saaE2w7RmbJJgvJ2oGNJ0DFzsV1nnuzEf/2RzXy28OscKq35lN32EN5WTejP0um7cWolFRSIuXWbIu/cGe1O/1Q
X-Gm-Message-State: AOJu0Yzen4fcOTWmOThuGZOomwtQkv39rYKQr5y+481Fb5jKHJXIUfae
	s1fVrfwOdmLPL2MxSyTNKru9U9knIKBKkdv+p6ni+7zuXsAowBsSEu1zMBct
X-Google-Smtp-Source: AGHT+IEdJEZPg4RmRriNJvZ9ahIM21K97ubmmeCO1CKYdbqQsQThckXb2cLmncRYSvscNc6GGM/MAQ==
X-Received: by 2002:a17:90b:18b:b0:28d:1e1b:d73b with SMTP id t11-20020a17090b018b00b0028d1e1bd73bmr549771pjs.19.1707462123256;
        Thu, 08 Feb 2024 23:02:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXAx3a693s2l69Ut2KmKGU4vE2ZC23IXFwaBq60nxdhXQH/wHqINSDRVEggFL83Uw2MwTD9HerALBagZpD8L1eLx4n8TkjqzJ1EGYIMSlHivyd5ypAco80tPfYCz8Hhg34bjv7ya4IYE/HbC0AqAGovAva0WfT4DoOWsO6umPQ+WPMNMsSVVAV6YrXzPXUNjf46OwTbAN+E3I9XhudqgT3G42OFW05p0f0ADTIl6+x+6xpc+BkKnDEuLGaBB/BqUB2jz51hr6LLF3YkHFzD8NghbacfpFpqTB42Io0ldUdysrN7sPlP4VBANUXFnYvnXnoZsg3HXxn21bbqXtbw8r/hLfPNYHjcYLXHdwKUrha44NHYGWm9DIneZWOA5u1atuzSBY0CETd4h9+sxh1mG7owCB0o0+ZXnqlFbAOozjeWyXn9jMGm+jqBMUF7S5W4yc/bzY/sAz8xGDJrLGWUVSy2CPWb1PfsKmTPZNmUM95l6OTokRvOeYdBLQBzEFZzMCIypPS85Ja35rox/gu4ZJdSZ7xbfoYZk4+nYnsWLWrlcarZSyzAyZ9l
Received: from wheely.local0.net ([1.146.102.26])
        by smtp.gmail.com with ESMTPSA id r10-20020a170903410a00b001d7284b9461sm839285pld.128.2024.02.08.23.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 23:02:02 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: [kvm-unit-tests PATCH v3 1/8] arch-run: Fix TRAP handler recursion to remove temporary files properly
Date: Fri,  9 Feb 2024 17:01:34 +1000
Message-ID: <20240209070141.421569-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240209070141.421569-1-npiggin@gmail.com>
References: <20240209070141.421569-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Migration files were not being removed when the QEMU process is
interrupted (e.g., with ^C). This is becaus the SIGINT propagates to the
bash TRAP handler, which recursively TRAPs due to the 'kill 0' in the
handler. This eventually crashes bash.

This can be observed by interrupting a long-running test program that is
run with MIGRATION=yes, /tmp/mig-helper-* files remain afterwards.

Removing TRAP recursion solves this problem and allows the EXIT handler
to run and clean up the files.

This also moves the trap handler before temp file creation, and expands
the name variables at trap-time rather than install-time, which closes
the small race between creation trap handler install.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 scripts/arch-run.bash | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index d0864360..11d47a85 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -129,6 +129,9 @@ run_migration ()
 		return 77
 	fi
 
+	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
+	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
+
 	migsock=$(mktemp -u -t mig-helper-socket.XXXXXXXXXX)
 	migout1=$(mktemp -t mig-helper-stdout1.XXXXXXXXXX)
 	qmp1=$(mktemp -u -t mig-helper-qmp1.XXXXXXXXXX)
@@ -137,9 +140,6 @@ run_migration ()
 	qmpout1=/dev/null
 	qmpout2=/dev/null
 
-	trap 'kill 0; exit 2' INT TERM
-	trap 'rm -f ${migout1} ${migsock} ${qmp1} ${qmp2} ${fifo}' RETURN EXIT
-
 	eval "$@" -chardev socket,id=mon1,path=${qmp1},server=on,wait=off \
 		-mon chardev=mon1,mode=control | tee ${migout1} &
 	live_pid=`jobs -l %+ | grep "eval" | awk '{print$2}'`
@@ -209,11 +209,11 @@ run_panic ()
 		return 77
 	fi
 
-	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
-
-	trap 'kill 0; exit 2' INT TERM
+	trap 'trap - TERM ; kill 0 ; exit 2' INT TERM
 	trap 'rm -f ${qmp}' RETURN EXIT
 
+	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
+
 	# start VM stopped so we don't miss any events
 	eval "$@" -chardev socket,id=mon1,path=${qmp},server=on,wait=off \
 		-mon chardev=mon1,mode=control -S &
-- 
2.42.0

